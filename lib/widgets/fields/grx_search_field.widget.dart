import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/typography/styles/grx_label_large_text.style.dart';
import '../buttons/grx_clear_input_button.widget.dart';
import 'grx_form_field.widget.dart';

final _inputTextStyle = GrxLabelLargeTextStyle(
  color: GrxColors.primary.shade800,
);

class GrxSearchField extends StatelessWidget {
  const GrxSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.searchFieldController,
    this.flexible = false,
  });

  final TextEditingController? searchFieldController;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool flexible;

  @override
  Widget build(BuildContext context) {
    return GrxFormField<String>(
      flexible: flexible,
      builder: (FormFieldState<String> field) {
        return TextField(
          controller: searchFieldController,
          autocorrect: false,
          style: _inputTextStyle,
          decoration: InputDecoration(
            suffixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 40,
            ),
            isDense: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            fillColor: GrxColors.neutrals,
            filled: true,
            suffixIcon:
                searchFieldController?.text.isEmpty ?? true
                    ? Icon(GrxIcons.search)
                    : GrxClearInputButton(
                      onClear: () {
                        searchFieldController?.clear();
                        onChanged?.call(searchFieldController?.text ?? '');
                      },
                    ),
            hintText: hintText,
            hintStyle: _inputTextStyle,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        );
      },
    );
  }
}
