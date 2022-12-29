import 'package:flutter/material.dart';
import 'package:grex_ds/utils/grx_utils.util.dart';

import '../../themes/colors/grx_colors.dart';

class GrxRoundedCheckbox extends StatefulWidget {
  const GrxRoundedCheckbox({
    super.key,
    this.initialValue = false,
    this.radius = 18,
    this.onChanged,
    this.isTappable = true,
    this.enabled = true,
  });

  final bool initialValue;
  final double radius;
  final Function(bool)? onChanged;
  final bool isTappable;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _GrxRoundedCheckboxState();
}

class _GrxRoundedCheckboxState extends State<GrxRoundedCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(GrxRoundedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.isTappable && widget.enabled
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
            color: _value ? GrxColors.cff1eb35e : GrxColors.cffdce2e8,
          ),
          color: _value ? GrxColors.cff1eb35e : GrxColors.cfff9fbfd,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedSwitcher(
            duration: GrxUtils.defaultAnimationDuration,
            child: SizedBox.fromSize(
              size: Size.fromRadius(widget.radius),
              child: _value
                  ? Icon(
                      Icons.check,
                      size: widget.radius * 2,
                      color: GrxColors.cffffffff,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
