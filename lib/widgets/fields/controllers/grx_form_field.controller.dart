import 'dart:async';

import 'package:flutter/material.dart';

class GrxFormFieldController<T> extends TextEditingController {
  final StreamController<void> onClearStream = StreamController.broadcast();
  final StreamController<Iterable<T>> onDidUpdateData =
      StreamController.broadcast();
  final StreamController<T?> onDidUpdateValue = StreamController.broadcast();

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

  void updateValue(T? value) {
    onDidUpdateValue.sink.add(value);
  }
}
