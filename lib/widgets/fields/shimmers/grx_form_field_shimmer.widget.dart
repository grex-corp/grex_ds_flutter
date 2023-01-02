import 'package:flutter/material.dart';

import '../../../themes/fields/grx_field_styles.theme.dart';
import '../grx_input_decoration.widget.dart';

class GrxFormFieldShimmer extends StatelessWidget {
  const GrxFormFieldShimmer({
    super.key,
    required this.labelText,
  });

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      baseStyle: GrxFieldStyles.inputTextStyle,
      decoration: GrxInputDecoration(
        labelText: labelText,
        enabled: false,
        showClearButton: false,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: GrxFieldStyles.inputText(
          'Default loading text',
          true,
        ),
      ),
    );
  }
}
