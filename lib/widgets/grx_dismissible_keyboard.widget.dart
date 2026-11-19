import 'package:material_ui/material_ui.dart';

class GrxDismissibleKeyboard extends GestureDetector {
  GrxDismissibleKeyboard({super.key, required Widget child})
    : super(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: child,
      );
}
