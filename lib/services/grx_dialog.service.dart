import 'package:flutter/material.dart';

import '../widgets/dialog/grx_dialog.widget.dart';

abstract class GrxDialogService {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    Widget? content,
    List<Widget> Function(BuildContext dialogContext)? actionsBuilder,
    MainAxisAlignment actionsAlignment = MainAxisAlignment.end,
    bool barrierDismissible = true,
    bool showCloseButton = true,
    VoidCallback? onClose,
    EdgeInsets? insetPadding,
    double maxWidth = 400,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return GrxDialog(
          title: title,
          description: description,
          content: content,
          actions: actionsBuilder?.call(dialogContext) ?? const [],
          actionsAlignment: actionsAlignment,
          showCloseButton: showCloseButton,
          onClose: onClose ?? () => Navigator.of(dialogContext).pop(),
          insetPadding: insetPadding,
          maxWidth: maxWidth,
        );
      },
    );
  }
}
