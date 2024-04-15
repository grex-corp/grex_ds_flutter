import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/typography/styles/grx_caption_large_text.style.dart';
import '../buttons/grx_clear_input_button.widget.dart';
import 'grx_form_field.widget.dart';

const _inputTextStyle = GrxCaptionLargeTextStyle(
  color: GrxColors.cff365278,
);

class GrxSearchField extends StatelessWidget {
  const GrxSearchField({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.searchFieldController,
    this.flexible = false,
  });

  final TextEditingController? searchFieldController;
  final Function(String) onChanged;
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
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            fillColor: GrxColors.cffffffff,
            filled: true,
            suffixIcon: searchFieldController?.text.isEmpty ?? true
                ? const Icon(
                    GrxIcons.search,
                    color: GrxColors.cff9bb2ce,
                  )
                : GrxClearInputButton(
                    onClear: () {
                      searchFieldController?.clear();
                      onChanged(searchFieldController?.text ?? '');
                    },
                  ),
            hintText: hintText,
            hintStyle: _inputTextStyle,
          ),
          onChanged: onChanged,
        );
      },
    );
  }
}
