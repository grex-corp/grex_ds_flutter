import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../typography/grx_body_text.widget.dart';
import 'grx_checkbox.widget.dart';

class GrxCheckboxListTile extends StatelessWidget {
  final String title;
  final bool value;
  final void Function()? onTap;
  final bool enabled;
  final bool isLoading;

  const GrxCheckboxListTile({
    super.key,
    required this.title,
    this.value = false,
    this.onTap,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GrxCheckbox(
              value: value,
              enabled: enabled,
              isLoading: isLoading,
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                child: GrxBodyText(
                  title,
                  color: GrxColors.primary.shade800
                      .withOpacity(enabled && !isLoading ? 1.0 : .5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
