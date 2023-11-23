import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/grx_form_field.util.dart';
import '../grx_stateful.widget.dart';
import 'controllers/grx_form_field.controller.dart';
import 'grx_form_field.widget.dart';
import 'grx_text_field.widget.dart';
import 'shimmers/grx_form_field_shimmer.widget.dart';

/// A Design System's [FormField] used like text fields.
class GrxTextFormField extends GrxStatefulWidget {
  GrxTextFormField({
    final Key? key,
    required this.labelText,
    this.controller,
    this.value,
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
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.focusNode,
    this.autoFocus = false,
    this.enabled = true,
    this.flexible = false,
    this.inputFormatters,
    this.isLoading = false,
    this.prefix,
  }) : super(
          key: key ?? ValueKey<int>(labelText.hashCode),
        );

  final GrxFormFieldController<String>? controller;
  final String? value;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String?)? onChanged;
  final FormFieldSetter<String?>? onSaved;
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
  final bool flexible;
  final List<TextInputFormatter>? inputFormatters;
  final bool isLoading;
  final Widget? prefix;

  @override
  State<StatefulWidget> createState() => _GrxTextFormFieldState();
}

class _GrxTextFormFieldState extends State<GrxTextFormField> {
  late final GrxFormFieldController<String> controller;

  var _notifyListeners = true;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? GrxFormFieldController<String>();

    if (widget.value != null) {
      controller.text = widget.value!;
      if (widget.onChanged != null) {
        widget.onChanged!(controller.text);
      }
    }

    _subscribeStreams();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    super.dispose();
  }

  void _subscribeStreams() {
    controller.onDidUpdateValue.stream.listen((data) {
      final (value, notifyListeners) = data;

      _notifyListeners = notifyListeners;

      if (value?.isEmpty ?? true) {
        controller.clear();
        return;
      }

      controller.text = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return GrxFormFieldShimmer(
        labelText: widget.labelText,
      );
    }

    return GrxFormField<String>(
      autovalidateMode: widget.autovalidateMode,
      initialValue: widget.value,
      onSaved: widget.onSaved,
      validator: widget.validator,
      enabled: widget.enabled,
      flexible: widget.flexible,
      builder: (FormFieldState<String> field) {
        GrxFormFieldUtils.onValueChange(
          field,
          controller,
          onChanged: (value) {
            if (!_notifyListeners) {
              _notifyListeners = true;
              return;
            }

            widget.onChanged?.call(value);
          },
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
          prefix: widget.prefix,
        );
      },
    );
  }
}
