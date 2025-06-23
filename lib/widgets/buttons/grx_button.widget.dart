import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grex_ds/utils/grx_utils.util.dart';

import '../../enums/grx_align.enum.dart';
import '../../enums/grx_text_transform.enum.dart';
import '../../themes/colors/grx_colors.dart';
import '../grx_measure_size.widget.dart';
import '../typography/grx_headline_small_text.widget.dart';

class GrxButton extends StatefulWidget {
  const GrxButton({
    super.key,
    required this.foregroundColor,
    this.text,
    this.textSpan,
    this.transform = GrxTextTransform.none,
    this.backgroundColor,
    this.onPressed,
    this.margin,
    this.height = 48,
    this.mainAxisSize = MainAxisSize.max,
    this.icon,
    this.iconAlign = GrxAlign.left,
    this.iconSize = 20,
    this.iconColor,
    this.iconPadding = 5,
    this.elevation = 5,
    this.shape,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    this.style,
    this.isLoading = false,
  }) : assert(text != null || textSpan != null);

  final String? text;
  final InlineSpan? textSpan;
  final GrxTextTransform transform;
  final void Function()? onPressed;
  final EdgeInsets? margin;
  final double? height;
  final MainAxisSize mainAxisSize;
  final Color? backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final GrxAlign iconAlign;
  final double iconSize;
  final Color? iconColor;
  final double iconPadding;
  final double elevation;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry padding;
  final TextStyle? style;
  final bool isLoading;

  @override
  State<GrxButton> createState() => _GrxButtonState();
}

class _GrxButtonState extends State<GrxButton> {
  Size? childSize;

  Widget _createWidgetIcon() {
    final iconAlignLeft = widget.iconAlign == GrxAlign.left;

    return Visibility(
      visible: widget.icon != null,
      child: Padding(
        padding: EdgeInsets.only(
            left: iconAlignLeft ? 0 : widget.iconPadding,
            right: iconAlignLeft ? widget.iconPadding : 0),
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: widget.iconColor ?? widget.foregroundColor,
        ),
      ),
    );
  }

  ButtonStyleButton _getButton({
    required final Widget child,
    required final ButtonStyle style,
  }) =>
      widget.backgroundColor != null
          ? ElevatedButton(
              onPressed: widget.onPressed,
              style: style,
              child: child,
            )
          : TextButton(
              onPressed: widget.onPressed,
              style: style,
              child: child,
            );

  @override
  Widget build(BuildContext context) {
    final isTextButton = widget.backgroundColor == null;
    final children = <Widget>[
      _createWidgetIcon(),
      Flexible(
        child: widget.textSpan != null
            ? GrxHeadlineSmallText.rich(
                widget.textSpan,
                color: widget.foregroundColor,
                textAlign: TextAlign.center,
                transform: widget.transform,
              )
            : GrxHeadlineSmallText(
                widget.text,
                color: widget.foregroundColor,
                textAlign: TextAlign.center,
                transform: widget.transform,
              ),
      ),
    ];

    return Container(
      margin: widget.margin,
      height: widget.height,
      child: _getButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: GrxColors.primary.shade800,
          elevation: isTextButton ? null : widget.elevation,
          padding: widget.padding,
          backgroundColor: widget.backgroundColor,
          disabledBackgroundColor: isTextButton
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.12)
              : null,
          shape: widget.shape,
        ),
        child: AnimatedSwitcher(
          duration: GrxUtils.defaultAnimationDuration,
          child: widget.isLoading
              ? SizedBox(
                  height: childSize?.height,
                  width: childSize?.height,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.foregroundColor,
                      ),
                    ),
                  ),
                )
              : MeasureSize(
                  onChange: (size) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => setState(
                        () => childSize = size,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: widget.mainAxisSize,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
        ),
      ),
    );
  }
}
