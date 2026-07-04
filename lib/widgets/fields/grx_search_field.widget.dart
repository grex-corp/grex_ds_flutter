import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/typography/styles/grx_label_large_text.style.dart';
import '../buttons/grx_clear_input_button.widget.dart';
import 'grx_form_field.widget.dart';

final _inputTextStyle = GrxLabelLargeTextStyle(
  color: GrxColors.primary.shade900,
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
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                width: 1,
                color: GrxColors.primary.shade50,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                width: 1,
                color: GrxColors.primary.shade50,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            fillColor: GrxColors.primary.withValues(alpha: 0.1),
            filled: true,
            prefixIcon: Icon(
              GrxIcons.search,
              color: GrxColors.primary.shade800,
            ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 40,
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 40,
            ),
            suffixIcon:
                searchFieldController?.text.isEmpty ?? true
                    ? const SizedBox.shrink()
                    : GrxClearInputButton(
                      onClear: () {
                        searchFieldController?.clear();
                        onChanged?.call(searchFieldController?.text ?? '');
                      },
                    ),
            hintText: hintText,
            hintStyle: _inputTextStyle.copyWith(
              color: GrxColors.primary.shade800,
            ),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        );
      },
    );
  }
}
