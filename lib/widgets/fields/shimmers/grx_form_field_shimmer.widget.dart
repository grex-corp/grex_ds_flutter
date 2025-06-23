import 'package:flutter/material.dart';
import 'package:grex_ds/themes/grx_theme_data.theme.dart';

import '../../../themes/spacing/grx_spacing.dart';
import '../../typography/grx_label_large_text.widget.dart';
import '../grx_input_decoration.widget.dart';

class GrxFormFieldShimmer extends StatelessWidget {
  const GrxFormFieldShimmer({super.key, required this.labelText});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      baseStyle: GrxThemeData.theme.textTheme.labelLarge,
      decoration: GrxInputDecoration(
        labelText: labelText,
        enabled: false,
        showClearButton: false,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: GrxSpacing.xs),
        child: GrxLabelLargeText('Default loading text', isLoading: true),
      ),
    );
  }
}
