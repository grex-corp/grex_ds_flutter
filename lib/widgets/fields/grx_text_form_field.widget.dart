import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

/// A Design System's [FormField] used like text fields.
class GrxTextFormField extends GrxStatefulWidget {
  GrxTextFormField({
    super.key,
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
    this.hintMaxLines,
    this.autovalidateMode = AutovalidateMode.always,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.focusNode,
    this.autoFocus = false,
    this.enabled = true,
    this.inputFormatters,
    this.isLoading = false,
  });

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
  final int? hintMaxLines;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final void Function(String?)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _GrxTextFormFieldState();
}

class _GrxTextFormFieldState extends State<GrxTextFormField> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();

    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
      if (widget.onChanged != null) {
        widget.onChanged!(controller.text);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return GrxFormFieldShimmer(
        labelText: widget.labelText,
      );
    }

    return FormField<String>(
      autovalidateMode: widget.autovalidateMode,
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: widget.onChanged,
        );

        return GrxTextField(
          controller: controller,
          focusNode: widget.focusNode,
          autofocus: widget.autoFocus,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          obscureText: widget.obscureText,
          autocorrect: false,
          textInputAction: widget.textInputAction,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          textAlignVertical: widget.textAlignVertical,
          onSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          labelText: widget.labelText,
          alignLabelWithHint: widget.alignLabelWithHint,
          contentPadding: widget.contentPadding,
          hintText: widget.hintText,
          hintMaxLines: widget.hintMaxLines,
          errorText: field.errorText,
          enabled: widget.enabled,
        );
      },
    );
  }
}
