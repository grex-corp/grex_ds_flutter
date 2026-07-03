import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/typography/styles/grx_label_large_text.style.dart';
import 'grx_input_decoration.widget.dart';

class GrxTextField extends StatefulWidget {
  const GrxTextField({
    super.key,
    this.readOnly = false,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.autofillHints,
    required this.controller,
    this.labelText,
    this.enabled = true,
    this.autocorrect = false,
    this.contentPadding,
    this.textCapitalization = TextCapitalization.sentences,
    this.textAlignVertical = TextAlignVertical.center,
    this.maxLines = 1,
    this.alignLabelWithHint = false,
    this.hintText,
    this.hintMaxLines,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.onClear,
    this.showClearButton = true,
    this.prefix,
    this.suffix,
    this.style,
    this.suffixIconConstraints,
  });

  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final bool enabled;
  final bool autocorrect;
  final EdgeInsets? contentPadding;
  final TextCapitalization textCapitalization;
  final TextAlignVertical textAlignVertical;
  final int? maxLines;
  final bool alignLabelWithHint;
  final String? hintText;
  final int? hintMaxLines;
  final String? errorText;
  final TextInputAction textInputAction;
  final VoidCallback? onClear;
  final bool showClearButton;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? style;
  final BoxConstraints? suffixIconConstraints;

  @override
  State<GrxTextField> createState() => _GrxTextFieldState();
}

class _GrxTextFieldState extends State<GrxTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(GrxTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted || !widget.showClearButton) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final canShowClear = widget.showClearButton && widget.enabled;

    return TextField(
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints,
      controller: widget.controller,
      autocorrect: widget.autocorrect,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: widget.textAlignVertical,
      textInputAction: widget.textInputAction,
      cursorColor: GrxColors.primary.shade900,
      style: widget.style ?? GrxLabelLargeTextStyle(),
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      decoration: GrxInputDecoration(
        labelText: widget.labelText,
        alignLabelWithHint: widget.alignLabelWithHint,
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        hintMaxLines: widget.hintMaxLines,
        errorText: widget.errorText,
        enabled: widget.enabled,
        onClear: widget.onClear ?? widget.controller.clear,
        showClearButton: canShowClear,
        isClearButtonVisible: canShowClear && widget.controller.text.isNotEmpty,
        prefix: widget.prefix,
        suffix: widget.suffix,
        suffixIconConstraints: widget.suffixIconConstraints,
      ),
    );
  }
}
