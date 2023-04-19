import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/system_overlay/grx_system_overlay.style.dart';
import '../../themes/typography/styles/grx_headline_medium_text.style.dart';
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
    this.foregroundColor = GrxColors.cff7593b5,
    this.actions = const [],
    this.showBackButton = false,
    this.showCloseButton = false,
    this.height = _kHeight,
    this.animationProgress = 0,
    final SystemUiOverlayStyle? systemOverlayStyle,
  }) : systemOverlayStyle = systemOverlayStyle ??
            (backgroundColor.computeLuminance() > .5
                ? GrxSystemOverlayStyle.dark
                : GrxSystemOverlayStyle.light);

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
      title: Padding(
        padding: EdgeInsets.lerp(EdgeInsets.zero,
            const EdgeInsets.only(left: 8.0), animationProgress)!,
        child: GrxText(
          title,
          style: TextStyle.lerp(
            GrxHeadlineTextStyle(color: foregroundColor),
            GrxHeadlineMediumTextStyle(color: foregroundColor),
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
          iconSize: 20.0,
        ),
      ),
      leadingWidth: showBackButton ? 48.0 : 16.0,
      titleSpacing: 0,
      toolbarHeight: height,
      actions: showCloseButton
          ? [
              GrxCloseButton(
                onPressed: Navigator.of(context).pop,
                color: foregroundColor,
              ),
            ]
          : actions
              .map(
                (e) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: (height -
                            GrxButtonUtils.buttonAnimationProgressCalc(
                                animationProgress)) /
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
