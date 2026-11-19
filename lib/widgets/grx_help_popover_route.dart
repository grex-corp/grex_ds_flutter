import 'package:material_ui/material_ui.dart';

import '../themes/colors/grx_colors.dart';
import '../utils/grx_utils.util.dart';
import 'grx_help_popover.widget.dart';

class GrxHelpPopoverRoute extends PopupRoute<void> {
  GrxHelpPopoverRoute({
    required this.anchor,
    required this.width,
    required this.child,
    required this.barrierLabel,
  });

  final Rect anchor;
  final double width;
  final Widget child;

  @override
  final String barrierLabel;

  @override
  Duration get transitionDuration => GrxUtils.defaultAnimationDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => GrxColors.neutrals.shade1000.withValues(alpha: 0.4);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return GrxHelpPopover(anchor: anchor, width: width, child: child);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
