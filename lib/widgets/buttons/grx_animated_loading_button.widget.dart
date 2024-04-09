import 'package:flutter/widgets.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../controllers/grx_animated_loading_button.controller.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../typography/grx_headline_small_text.widget.dart';

class GrxAnimatedLoadingButton extends StatelessWidget {
  GrxAnimatedLoadingButton({
    super.key,
    required this.onPressed,
    this.text,
    this.textSpan,
    this.transform = GrxTextTransform.none,
    this.foregroundColor = GrxColors.cffffffff,
    this.backgroundColor = GrxColors.c7075f3aa,
    this.height = 48.0,
    this.width,
    this.margin,
    this.animateOnTap = false,
    final GrxAnimatedLoadingButtonController? controller,
  })  : controller = controller ?? GrxAnimatedLoadingButtonController(),
        assert(text != null || textSpan != null);

  final GrxAnimatedLoadingButtonController controller;
  final void Function(GrxAnimatedLoadingButtonController controller) onPressed;
  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final Color foregroundColor;
  final Color backgroundColor;
  final double height;
  final double? width;
  final EdgeInsets? margin;
  final bool animateOnTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32.0;

    return Container(
      margin: margin,
      child: RoundedLoadingButton(
        controller: controller,
        onPressed: () => onPressed(controller),
        borderRadius: height / 2,
        color: backgroundColor,
        errorColor: GrxColors.cfffc5858,
        successColor: GrxColors.primarySwatch,
        animateOnTap: animateOnTap,
        width: this.width ?? width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: textSpan != null
              ? GrxHeadlineSmallText.rich(
                  textSpan,
                  color: foregroundColor,
                  textAlign: TextAlign.center,
                  transform: transform,
                )
              : GrxHeadlineSmallText(
                  text,
                  color: foregroundColor,
                  textAlign: TextAlign.center,
                  transform: transform,
                ),
        ),
      ),
    );
  }
}
