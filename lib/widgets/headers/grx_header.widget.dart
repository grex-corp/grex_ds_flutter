import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../../themes/system_overlay/grx_system_overlay.style.dart';
import '../../themes/typography/styles/grx_headline_text.style.dart';
import '../../utils/grx_button.util.dart';
import '../buttons/grx_back_button.widget.dart';
import '../buttons/grx_close_button.widget.dart';
import '../typography/grx_text.widget.dart';

const double _kHeight = 60;

class GrxHeader extends StatelessWidget implements PreferredSizeWidget {
  GrxHeader({
    super.key,
    required this.title,
    this.backgroundColor = Colors.transparent,
    this.actions = const [],
    this.showBackButton = false,
    this.showCloseButton = false,
    this.height = _kHeight,
    this.animationProgress = 0,
    final Color? foregroundColor,
    final SystemUiOverlayStyle? systemOverlayStyle,
  }) : systemOverlayStyle =
           systemOverlayStyle ??
           (backgroundColor.computeLuminance() > .5
               ? GrxSystemOverlayStyle.dark
               : GrxSystemOverlayStyle.light),
       foregroundColor = foregroundColor ?? GrxColors.primary.shade800;

  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final List<Widget> actions;
  final bool showBackButton;
  final bool showCloseButton;
  final double height;
  final double animationProgress;
  final SystemUiOverlayStyle systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: Padding(
        padding:
            EdgeInsets.lerp(
              EdgeInsets.zero,
              const EdgeInsets.only(left: 4.0),
              animationProgress,
            )!,
        child: GrxText(
          title,
          style:
              TextStyle.lerp(
                GrxHeadlineTextStyle(color: foregroundColor),
                GrxHeadlineTextStyle(color: foregroundColor),
                animationProgress,
              )!,
        ),
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      systemOverlayStyle: systemOverlayStyle,
      leading: Visibility(
        visible: showBackButton,
        child: GrxBackButton(
          onPressed: Navigator.of(context).pop,
          color: foregroundColor,
          size: 20.0 - 2.0 * animationProgress,
        ),
      ),
      leadingWidth: showBackButton ? 48.0 : 16.0,
      titleSpacing: 0.0,
      toolbarHeight: height,
      actions:
          showCloseButton
              ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: GrxSpacing.sm),
                  child: GrxCloseButton(
                    onPressed: Navigator.of(context).pop,
                    color: foregroundColor,
                  ),
                ),
              ]
              : actions
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical:
                            (height -
                                GrxButtonUtils.buttonAnimationProgressCalc(
                                  animationProgress,
                                )) /
                            2,
                        horizontal: 6.0,
                      ),
                      child: e,
                    ),
                  )
                  .toList(),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
