import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GrxFormFieldController<T> extends TextEditingController {
  GrxFormFieldController({
    super.text,
    final String? mask,
  }) : maskFormatter = mask?.isNotEmpty ?? false
            ? MaskTextInputFormatter(
                mask: '#####-###',
                filter: {
                  "#": RegExp(r'[0-9]'),
                },
                initialText: text,
                type: text?.isNotEmpty ?? false
                    ? MaskAutoCompletionType.eager
                    : MaskAutoCompletionType.lazy,
              )
            : null;

  final StreamController<void> onClearStream = StreamController.broadcast();
  final StreamController<Iterable<T>> onDidUpdateData =
      StreamController.broadcast();
  final StreamController<(T?, bool)> onDidUpdateValue =
      StreamController.broadcast();

  late final MaskTextInputFormatter? maskFormatter;

  @override
  bool get hasListeners => super.hasListeners;

  @override
  void dispose() {
    onClearStream.close();
    onDidUpdateData.close();
    onDidUpdateValue.close();

    super.dispose();
  }

  @override
  void clear() {
    super.clear();

    onClearStream.sink.add(null);
  }

  void updateData(Iterable<T> data) {
    onDidUpdateData.sink.add(data);
  }

  void updateValue(
    T? value, {
    bool notifyListeners = true,
  }) {
    if (maskFormatter != null) {
      if (value is String) {
        value = maskText(value)! as T;

        maskFormatter?.updateMask(
          mask: maskFormatter?.getMask(),
          newValue: TextEditingValue(
            text: value as String,
          ),
        );
      }
    }

    onDidUpdateValue.sink.add((value, notifyListeners));
  }

  TextEditingValue? updateMask(
    String? mask, {
    TextEditingValue? newValue,
  }) =>
      maskFormatter?.updateMask(
        mask: mask,
        newValue: newValue,
      );

  String? getMaskedText() => maskFormatter?.getMaskedText();

  String? getUnmaskedText() => maskFormatter?.getUnmaskedText();

  String? maskText(String text) => maskFormatter?.maskText(text);

  String? getMask() => maskFormatter?.getMask();

  void clearMask() => maskFormatter?.clear();
}
