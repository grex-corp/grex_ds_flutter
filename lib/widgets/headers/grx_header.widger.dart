import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/system_overlay/grx_system_overlay.style.dart';
import '../buttons/grx_back_button.widget.dart';
import '../buttons/grx_close_button.widget.dart';
import '../typography/grx_headline_medium_text.widget.dart';

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
  }) {
    isLightBackground = backgroundColor.computeLuminance() > .5;
  }

  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final List<Widget> actions;
  final bool showBackButton;
  final bool showCloseButton;
  final double height;
  late final bool isLightBackground;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GrxHeadlineMediumText(
        title,
        color: foregroundColor,
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      systemOverlayStyle: isLightBackground
          ? GrxSystemOverlayStyle.dark
          : GrxSystemOverlayStyle.light,
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
                    vertical: (height - 48.0) / 2,
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
