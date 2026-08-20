import 'package:flutter/widgets.dart';

import '../../animations/grx_fade_transition.animation.dart';
import '../../models/grx_button_options.model.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/radius/grx_radius.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../buttons/grx_rounded_button.widget.dart';
import '../typography/grx_body_text.widget.dart';
import '../typography/grx_title_large_text.widget.dart';

class GrxListError extends StatelessWidget {
  GrxListError({
    super.key,
    required this.title,
    required this.subTitle,
    this.icon = const Icon(GrxIcons.circle_warning, size: 86.0),
    this.buttonOptions,
    this.animationController,
  }) : animation =
           animationController != null
               ? Tween<double>(begin: 0.0, end: 1.0).animate(
                 CurvedAnimation(
                   parent: animationController,
                   curve: const Interval(.3, 1.0, curve: Curves.fastOutSlowIn),
                 ),
               )
               : null;

  final String title;
  final String subTitle;
  final Widget? icon;
  final GrxButtonOptions? buttonOptions;
  final AnimationController? animationController;
  final Animation<double>? animation;

  Widget _buildErrorListWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Container(
                margin: const EdgeInsets.only(bottom: GrxSpacing.m),
                padding: const EdgeInsets.all(GrxSpacing.m),
                decoration: BoxDecoration(
                  color:
                      icon is Icon
                          ? (icon as Icon).color?.withAlpha((0.1 * 255).round())
                          : null,

                  borderRadius: BorderRadius.circular(GrxRadius.round),
                ),
                child: icon,
              ),
            GrxTitleLargeText(
              title,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GrxSpacing.s),
            GrxBodyText(
              subTitle,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            if (buttonOptions != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: GrxSpacing.l),
                child: GrxRoundedButton(
                  text: buttonOptions!.title,
                  foregroundColor: buttonOptions!.foregroundColor,
                  backgroundColor: buttonOptions!.backgroundColor,
                  icon: buttonOptions!.icon,
                  onPressed: buttonOptions!.onPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return animationController != null
        ? AnimatedBuilder(
          animation: animationController!,
          child: _buildErrorListWidget(),
          builder: (context, child) {
            return GrxFadeTransition(animation: animation!, child: child!);
          },
        )
        : _buildErrorListWidget();
  }
}
