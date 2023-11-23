import 'dart:async';

import 'package:flutter/material.dart';

class GrxFormFieldController<T> extends TextEditingController {
  final StreamController<void> onClearStream = StreamController.broadcast();
  final StreamController<Iterable<T>> onDidUpdateData =
      StreamController.broadcast();
  final StreamController<(T?, bool)> onDidUpdateValue =
      StreamController.broadcast();

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
    onDidUpdateValue.sink.add((value, notifyListeners));
  }
}
