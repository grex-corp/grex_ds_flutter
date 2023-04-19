import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/fields/grx_field_styles.theme.dart';
import '../../themes/icons/grx_icons.dart';

class GrxSearchField extends StatelessWidget {
  const GrxSearchField({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.searchFieldController,
  });

  final Function(String) onChanged;
  final String hintText;
  final TextEditingController? searchFieldController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchFieldController,
      autocorrect: false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 15),
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
        suffixIcon: const Icon(
          GrxIcons.search,
          color: GrxColors.cff9bb2ce,
        ),
        hintText: hintText,
        hintStyle: GrxFieldStyles.inputHintTextStyle,
      ),
      onChanged: onChanged,
    );
  }
}
