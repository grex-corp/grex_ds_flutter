import 'package:material_ui/material_ui.dart';

import '../themes/icons/grx_icons.dart';
import '../themes/spacing/grx_spacing.dart';
import 'grx_help_popover_route.dart';
import 'typography/grx_label_text.widget.dart';

class GrxHelpWidget extends StatefulWidget {
  const GrxHelpWidget({super.key, this.text, this.body, this.width})
    : assert(text != null || body != null);

  final String? text;
  final Widget? body;
  final double? width;

  @override
  State<GrxHelpWidget> createState() => _GrxHelpWidgetState();
}

class _GrxHelpWidgetState extends State<GrxHelpWidget> {
  NavigatorState? _navigator;
  Route<void>? _route;

  @override
  void dispose() {
    final route = _route;
    if (route != null && route.isActive) {
      _navigator?.removeRoute(route);
    }
    _route = null;
    super.dispose();
  }

  void _show() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    final previous = _route;
    if (previous != null && previous.isActive) {
      navigator.removeRoute(previous);
    }

    final route = GrxHelpPopoverRoute(
      anchor: box.localToGlobal(Offset.zero) & box.size,
      width: widget.width ?? MediaQuery.sizeOf(context).width - GrxSpacing.l,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      child:
          widget.body ??
          Padding(
            padding: const EdgeInsets.all(GrxSpacing.m),
            child: GrxLabelText(widget.text!, overflow: TextOverflow.visible),
          ),
    );
    _navigator = navigator;
    _route = route;
    navigator.push(route).whenComplete(() {
      if (identical(_route, route)) _route = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _show,
      child: const Icon(GrxIcons.circle_info, size: 20.0),
    );
  }
}
