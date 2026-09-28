import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import '../themes/colors/grx_colors.dart';
import '../themes/system_overlay/grx_system_overlay.style.dart';
import '../widgets/headers/grx_header.widget.dart';

const _kTransitionDuration = Duration(milliseconds: 320);
const _kDismissDistance = 120.0;
const _kDismissSpeed = 1100.0;
const _kFadeDistance = 360.0;
const _kDragSlop = 12.0;

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.image,
    required this.title,
    this.sourceRect,
  });

  final ImageProvider image;
  final String title;
  final Rect? Function()? sourceRect;

  static Route<void> route({
    required ImageProvider image,
    required String title,
    Rect? Function()? sourceRect,
  }) {
    return _ImagePreviewRoute(
      builder:
          (_) =>
              ImagePreview(image: image, title: title, sourceRect: sourceRect),
    );
  }

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview>
    with TickerProviderStateMixin {
  late final AnimationController _presentation;
  late final CurvedAnimation _presentationCurve;
  late final AnimationController _settle;

  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;
  ImageProvider? _resolvedImage;
  Size? _imageSize;

  int _pointers = 0;
  bool _session = false;
  bool _moved = false;
  bool _closing = false;
  bool _allowPop = false;
  bool _canDismiss = true;

  Offset _origin = Offset.zero;
  Offset _dragOffset = Offset.zero;
  Offset _settleFrom = Offset.zero;
  late VelocityTracker _velocityTracker;

  @override
  void initState() {
    super.initState();
    _velocityTracker = VelocityTracker.withKind(PointerDeviceKind.touch);
    _presentation = AnimationController(
      vsync: this,
      duration: _kTransitionDuration,
    )..addStatusListener(_onPresentationStatus);
    _presentationCurve = CurvedAnimation(
      parent: _presentation,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    )..addListener(_onPresentationTick);
    _settle = AnimationController.unbounded(vsync: this)
      ..addListener(_onSettle);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_closing) _presentation.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(ImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolveImage();
  }

  @override
  void dispose() {
    _stopImageStream();
    _presentation.removeStatusListener(_onPresentationStatus);
    _presentationCurve.removeListener(_onPresentationTick);
    _presentationCurve.dispose();
    _presentation.dispose();
    _settle.removeListener(_onSettle);
    _settle.dispose();
    super.dispose();
  }

  void _onPresentationTick() {
    if (mounted) setState(() {});
  }

  void _resolveImage() {
    if (_resolvedImage == widget.image) return;

    _stopImageStream();
    _resolvedImage = widget.image;
    final stream = widget.image.resolve(const ImageConfiguration());
    _imageStream = stream;
    _imageListener = ImageStreamListener((info, _) {
      if (!mounted) return;
      final size = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
      if (size == _imageSize) return;
      setState(() => _imageSize = size);
    }, onError: (_, _) {});
    stream.addListener(_imageListener!);
  }

  void _stopImageStream() {
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
    _imageStream = null;
    _imageListener = null;
  }

  void _onPresentationStatus(AnimationStatus status) {
    if (status != AnimationStatus.dismissed || !_closing || !mounted) return;

    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _onSettle() {
    setState(() {
      _dragOffset = Offset.lerp(_settleFrom, Offset.zero, _settle.value)!;
    });
  }

  void _onScaleStateChanged(PhotoViewScaleState state) {
    _canDismiss =
        state == PhotoViewScaleState.initial ||
        state == PhotoViewScaleState.zoomedOut;

    if (_canDismiss || !_session) return;
    _session = false;
    _moved = false;
    _springToRest();
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointers++;
    if (_closing) return;

    if (_pointers > 1) {
      if (_session) {
        _session = false;
        _moved = false;
        _springToRest();
      }
      return;
    }

    if (!_canDismiss || _presentation.status != AnimationStatus.completed) {
      return;
    }

    _settle.stop();
    _session = true;
    _moved = _dragOffset.distance >= _kDragSlop;
    _origin = event.position - _dragOffset;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_session || _pointers != 1 || _closing) return;

    _velocityTracker.addPosition(event.timeStamp, event.position);
    final delta = event.position - _origin;
    if (!_moved && delta.distance < _kDragSlop) return;

    _moved = true;
    setState(() => _dragOffset = delta);
  }

  void _onPointerUp(PointerUpEvent event) {
    _pointers = (_pointers - 1).clamp(0, 16);
    if (!_session) return;

    _session = false;
    if (!_moved || _closing) return;

    _velocityTracker.addPosition(event.timeStamp, event.position);
    _finishDrag(_velocityTracker.getVelocity().pixelsPerSecond);
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointers = (_pointers - 1).clamp(0, 16);
    if (!_session) return;

    _session = false;
    if (_moved && !_closing) _springToRest();
  }

  void _finishDrag(Offset velocity) {
    final distance = _dragOffset.distance;
    final speed = velocity.distance;
    final away = velocity.dx * _dragOffset.dx + velocity.dy * _dragOffset.dy;
    final flickedAway = speed > _kDismissSpeed && distance > 48 && away > 0;
    final pulledAway = distance > _kDismissDistance && away >= 0;

    if (pulledAway || flickedAway) {
      _dismiss();
      return;
    }

    _springToRest();
  }

  void _dismiss() {
    if (_closing) return;
    _closing = true;
    _session = false;
    _settle.stop();

    if (_presentation.value == 0) {
      _onPresentationStatus(AnimationStatus.dismissed);
      return;
    }

    _presentation.reverse();
  }

  void _springToRest() {
    if (_dragOffset.distance < 0.5) {
      if (_dragOffset != Offset.zero) {
        setState(() => _dragOffset = Offset.zero);
      }
      return;
    }

    _settle.stop();
    _settleFrom = _dragOffset;
    _settle.value = 0;
    _settle.animateWith(
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 380, damping: 28),
        0,
        1,
        _dragOffset.distance / 1000,
      ),
    );
  }

  Rect? _sourceInPreview(BuildContext context) {
    final global = widget.sourceRect?.call();
    if (global == null || global.isEmpty || !global.isFinite) return null;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return global;
    return box.globalToLocal(global.topLeft) & global.size;
  }

  Rect _containedRect(Size screen) {
    final image = _imageSize;
    if (image == null || image.width <= 0 || image.height <= 0) {
      final side = screen.shortestSide;
      return Rect.fromCenter(
        center: screen.center(Offset.zero),
        width: side,
        height: side,
      );
    }

    final fitted = applyBoxFit(BoxFit.contain, image, screen).destination;
    return Rect.fromCenter(
      center: screen.center(Offset.zero),
      width: fitted.width,
      height: fitted.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = _presentationCurve.value.clamp(0.0, 1.0);
    final dragFade = (_dragOffset.distance / _kFadeDistance).clamp(0.0, 1.0);
    final scrimOpacity = (t * (1 - dragFade)).clamp(0.0, 1.0);
    final interactive =
        _presentation.status == AnimationStatus.completed && !_closing;

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || _closing) return;
        _dismiss();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            scrimOpacity > 0.45
                ? GrxSystemOverlayStyle.light
                : GrxSystemOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: GrxColors.transparent,
          body: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screen = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                final contained = _containedRect(screen);
                final source = _sourceInPreview(context);
                final dragScale = _lerp(1, 0.78, dragFade);
                final dragged = Rect.fromCenter(
                  center: contained.center + _dragOffset,
                  width: contained.width * dragScale,
                  height: contained.height * dragScale,
                );
                final destination =
                    source ??
                    Rect.fromCenter(
                      center: contained.center,
                      width: contained.width * 0.15,
                      height: contained.height * 0.15,
                    );
                final display = Rect.lerp(destination, dragged, t)!;
                final radius =
                    source == null
                        ? 0.0
                        : _lerp(
                          source.shortestSide / 2,
                          0,
                          t,
                        ).clamp(0.0, display.shortestSide / 2);
                final scaleX =
                    contained.width == 0
                        ? 1.0
                        : display.width / contained.width;
                final scaleY =
                    contained.height == 0
                        ? 1.0
                        : display.height / contained.height;
                final moving =
                    (scaleX - 1).abs() > 0.001 ||
                    (scaleY - 1).abs() > 0.001 ||
                    (display.center - contained.center).distance > 0.5;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: GrxColors.neutrals.shade900.withValues(
                        alpha: scrimOpacity,
                      ),
                    ),
                    Positioned.fill(
                      child: ClipPath(
                        clipper: _RRectClipper(
                          rect: radius > 0.5 ? display : null,
                          radius: radius,
                        ),
                        child: Transform.translate(
                          offset: display.center - contained.center,
                          child: Transform.scale(
                            scaleX: scaleX.isFinite && scaleX > 0 ? scaleX : 1,
                            scaleY: scaleY.isFinite && scaleY > 0 ? scaleY : 1,
                            filterQuality:
                                moving
                                    ? FilterQuality.medium
                                    : FilterQuality.none,
                            child: IgnorePointer(
                              ignoring: !interactive,
                              child: PhotoView(
                                imageProvider: widget.image,
                                backgroundDecoration: const BoxDecoration(
                                  color: GrxColors.transparent,
                                ),
                                minScale: PhotoViewComputedScale.contained,
                                initialScale: PhotoViewComputedScale.contained,
                                basePosition: Alignment.center,
                                gaplessPlayback: true,
                                scaleStateChangedCallback: _onScaleStateChanged,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        ignoring: scrimOpacity < 0.4,
                        child: Opacity(
                          opacity: scrimOpacity,
                          child: SafeArea(
                            bottom: false,
                            child: GrxHeader(
                              title: widget.title,
                              foregroundColor: GrxColors.neutrals,
                              showBackButton: false,
                              showCloseButton: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

class _RRectClipper extends CustomClipper<Path> {
  const _RRectClipper({required this.rect, required this.radius});

  final Rect? rect;
  final double radius;

  @override
  Path getClip(Size size) {
    if (rect == null) {
      return Path()..addRect(Offset.zero & size);
    }

    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect!, Radius.circular(radius)));
  }

  @override
  bool shouldReclip(_RRectClipper oldDelegate) {
    return oldDelegate.rect != rect || oldDelegate.radius != radius;
  }
}

class _ImagePreviewRoute extends PageRoute<void> {
  _ImagePreviewRoute({required this.builder}) : super(fullscreenDialog: true);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => Duration.zero;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }
}
