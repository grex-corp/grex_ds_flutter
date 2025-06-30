import 'package:flutter/material.dart';

class GrxDismissibleKeyboard extends GestureDetector {
  GrxDismissibleKeyboard({super.key, required final Widget child})
    : super(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: child,
      );
}
