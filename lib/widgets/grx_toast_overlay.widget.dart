import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../themes/spacing/grx_spacing.dart';
import '../utils/grx_utils.util.dart';

class GrxToastOverlay extends StatefulWidget {
  const GrxToastOverlay({
    super.key,
    required this.child,
    required this.duration,
    required this.autoDismiss,
    required this.onRemove,
  });

  final Widget child;
  final Duration duration;
  final bool autoDismiss;
  final VoidCallback onRemove;

  @override
  State<GrxToastOverlay> createState() => _GrxToastOverlayState();
}

class _GrxToastOverlayState extends State<GrxToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;
  var _removed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: GrxUtils.defaultAnimationDuration,
    )..forward();
    if (widget.autoDismiss) {
      _timer = Timer(widget.duration, _dismiss);
    }
  }

  @override
  void dispose() {
    _removed = true;
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted || _removed) return;
    try {
      await _controller.reverse();
    } on TickerCanceled {
      return;
    }
    if (!mounted || _removed) return;
    _remove();
  }

  void _remove() {
    if (_removed) return;
    _removed = true;
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: GrxSpacing.m),
          child: Dismissible(
            key: const ValueKey('grx-toast'),
            direction: DismissDirection.horizontal,
            onDismissed: (_) => _remove(),
            child: FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
