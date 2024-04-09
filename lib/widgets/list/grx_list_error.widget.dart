import 'package:flutter/widgets.dart';

import '../../animations/grx_fade_transition.animation.dart';
import '../../models/grx_button_options.model.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../buttons/grx_rounded_button.widget.dart';
import '../typography/grx_caption_large_text.widget.dart';
import '../typography/grx_headline_text.widget.dart';

class GrxListError extends StatelessWidget {
  GrxListError({
    super.key,
    required this.title,
    required this.subTitle,
    this.icon = const Icon(
      GrxIcons.error_outline,
      size: 86.0,
      color: GrxColors.cff7593b5,
    ),
    this.buttonOptions,
    this.animationController,
  }) : animation = animationController != null
            ? Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(
                    .3,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
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
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 32.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                child: icon,
              ),
            GrxHeadlineText(
              title,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8.0,
            ),
            GrxCaptionLargeText(
              subTitle,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            if (buttonOptions != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
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
              return GrxFadeTransition(
                animation: animation!,
                child: child!,
              );
            },
          )
        : _buildErrorListWidget();
  }
}
