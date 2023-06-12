import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../enums/grx_country_id.enum.dart';
import '../../models/grx_country.model.dart';
import '../../services/grx_bottom_sheet.service.dart';
import '../../themes/colors/grx_colors.dart';
import '../../themes/icons/grx_icons.dart';
import '../../utils/grx_utils.util.dart';
import '../bottom_sheet/ds_bottom_sheet_countries.widget.dart';
import '../grx_stateful.widget.dart';
import '../media/grx_svg.widget.dart';
import '../typography/grx_caption_large_text.widget.dart';
import 'grx_text_form_field.widget.dart';

class GrxPhoneFormField extends GrxStatefulWidget {
  GrxPhoneFormField({
    final Key? key,
    required this.labelText,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.contentPadding,
    this.textCapitalization = TextCapitalization.sentences,
    this.textAlignVertical = TextAlignVertical.center,
    this.maxLines = 1,
    this.alignLabelWithHint = false,
    this.hintText,
    this.selectBottomSheetTitle,
    this.hintMaxLines,
    this.autovalidateMode = AutovalidateMode.always,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.focusNode,
    this.autoFocus = false,
    this.enabled = true,
    this.flexible = false,
    this.isLoading = false,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
        );

  final TextEditingController? controller;
  final String? initialValue;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String?>? validator;
  final EdgeInsets? contentPadding;
  final TextCapitalization textCapitalization;
  final TextAlignVertical textAlignVertical;
  final int? maxLines;
  final bool alignLabelWithHint;
  final String? hintText;
  final String? selectBottomSheetTitle;
  final int? hintMaxLines;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final void Function(String?)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool enabled;
  final bool flexible;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxPhoneFormFieldState();
}

class _GrxPhoneFormFieldState extends State<GrxPhoneFormField> {
  late final controller = widget.controller ?? TextEditingController();
  late final maskFormatter = MaskTextInputFormatter(
    mask: _getMask(
      country: selectedCountry,
      value: widget.initialValue,
    ),
    filter: {
      "#": RegExp(r'[0-9]'),
    },
    initialText: widget.initialValue,
    type: widget.initialValue?.isNotEmpty ?? false
        ? MaskAutoCompletionType.eager
        : MaskAutoCompletionType.lazy,
  );

  GrxCountry selectedCountry = GrxUtils.countriesList.first;

  String _getMask({required final GrxCountry country, final String? value}) {
    switch (country.id) {
      case GrxCountryId.BR:
        return (value?.replaceAll(RegExp('[^0-9]'), '').length ?? 0) <= 10
            ? country.phoneMasks[0]
            : country.phoneMasks[1];
      default:
        return country.phoneMasks.isNotEmpty
            ? country.phoneMasks[0]
            : '###############';
    }
  }

  String? _getFullNumber() {
    final phone = maskFormatter.getUnmaskedText();
    return phone.isNotEmpty
        ? '${selectedCountry.code}${maskFormatter.getUnmaskedText()}'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return GrxTextFormField(
      controller: controller,
      initialValue: maskFormatter.getMaskedText(),
      labelText: widget.labelText,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      prefix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              final bottomSheet = GrxBottomSheetService(
                context: context,
                title: widget.selectBottomSheetTitle ?? 'Select Country',
                builder: (controller) {
                  return GrxBottomSheetCountries(
                    selectedCountry: selectedCountry,
                  );
                },
              );

              final result = await bottomSheet.show<GrxCountry>();

              if (result != null) {
                setState(() {
                  selectedCountry = result;
                });

                controller.value = maskFormatter.updateMask(
                  mask: _getMask(
                    country: selectedCountry,
                    value: controller.text,
                  ),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GrxSvg(
                  'assets/svgs/flags/${selectedCountry.flag}.svg',
                  package: GrxUtils.packageName,
                  width: 22.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    GrxIcons.arrow_drop_down,
                    size: 18.0,
                    color: GrxColors.cff2e2e2e,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: GrxCaptionLargeText(
              selectedCountry.code,
            ),
          ),
        ],
      ),
      onChanged: (value) {
        if (value?.isNotEmpty ?? false) {
          final rawText = maskFormatter.getUnmaskedText();

          if (rawText.length == 10 || rawText.length == 11) {
            controller.value = maskFormatter.updateMask(
              mask: _getMask(
                country: selectedCountry,
                value: rawText,
              ),
            );
          }
        } else {
          maskFormatter.clear();
        }

        widget.onChanged?.call(value);
      },
      onSaved: (value) => widget.onSaved?.call(_getFullNumber()),
      validator: (value) => widget.validator?.call(_getFullNumber()),
      contentPadding: widget.contentPadding,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: widget.textAlignVertical,
      maxLines: widget.maxLines,
      alignLabelWithHint: widget.alignLabelWithHint,
      hintText: widget.hintText,
      hintMaxLines: widget.hintMaxLines,
      autovalidateMode: widget.autovalidateMode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      focusNode: widget.focusNode,
      autoFocus: widget.autoFocus,
      enabled: widget.enabled,
      flexible: widget.flexible,
      inputFormatters: [
        maskFormatter,
      ],
      isLoading: widget.isLoading,
    );
  }
}
