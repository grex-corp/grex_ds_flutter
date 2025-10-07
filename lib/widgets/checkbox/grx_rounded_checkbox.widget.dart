import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../utils/grx_utils.util.dart';

class GrxRoundedCheckbox extends StatefulWidget {
  const GrxRoundedCheckbox({
    super.key,
    this.value = false,
    this.radius = 18,
    this.onChanged,
    this.isTappable = true,
    this.enabled = true,
    this.isLoading = false,
  });

  final bool value;
  final double radius;
  final Function(bool)? onChanged;
  final bool isTappable;
  final bool enabled;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxRoundedCheckboxState();
}

class _GrxRoundedCheckboxState extends State<GrxRoundedCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();

    _value = widget.value;
  }

  @override
  void didUpdateWidget(GrxRoundedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final double opacity = widget.enabled && !widget.isLoading ? 255 : 128;

    return InkWell(
      splashColor: Colors.transparent,
      onTap:
          widget.isTappable && widget.enabled && !widget.isLoading
              ? () {
                setState(() {
                  _value = !_value;
                  if (widget.onChanged != null) {
                    widget.onChanged!(_value);
                  }
                });
              }
              : null,
      child: AnimatedContainer(
        duration: GrxUtils.defaultAnimationDuration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color:
                _value
                    ? GrxColors.success.shade300.withValues(alpha: opacity)
                    : GrxColors.neutrals.shade100.withValues(alpha: opacity),
          ),
          color:
              _value
                  ? GrxColors.success.shade300.withValues(alpha: opacity)
                  : GrxColors.neutrals.withValues(alpha: opacity),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedSwitcher(
            duration: GrxUtils.defaultAnimationDuration,
            child: SizedBox.fromSize(
              size: Size.fromRadius(widget.radius),
              child:
                  _value
                      ? Icon(
                        Icons.check,
                        size: widget.radius * 2,
                        color: GrxColors.neutrals.withValues(alpha: opacity),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
