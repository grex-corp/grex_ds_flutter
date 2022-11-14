import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:grex_ds/utils/grx_utils.util.dart';

class GrxCheckbox extends StatelessWidget {
  const GrxCheckbox({
    super.key,
    this.isChecked = false,
  });

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: GrxColors.cfff9fbfd,
        border: Border.all(color: GrxColors.cffdce2e8, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: GrxUtils.defaultAnimationDuration,
          decoration: BoxDecoration(
            color: isChecked ? GrxColors.cff289fff : Colors.transparent,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    );
  }
}
