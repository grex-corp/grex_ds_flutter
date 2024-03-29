import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../themes/typography/styles/grx_caption_large_text.style.dart';
import '../buttons/grx_clear_input_button.widget.dart';

const _inputTextStyle = GrxCaptionLargeTextStyle(color: GrxColors.cff7892b7);

class GrxFilterField extends StatelessWidget {
  final TextEditingController searchFieldController;
  final Function(String) onChanged;
  final String hintText;

  const GrxFilterField({
    super.key,
    required this.searchFieldController,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
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
            fillColor: GrxColors.cffe8f2ff,
            filled: true,
            suffixIcon: searchFieldController.text.isEmpty
                ? const Icon(
                    GrxIcons.search,
                    color: GrxColors.cff9bb2ce,
                  )
                : GrxClearInputButton(
                    onClear: () {
                      searchFieldController.clear();
                      onChanged(searchFieldController.text);
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
