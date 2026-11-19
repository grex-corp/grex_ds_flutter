import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../models/grx_toast_action.model.dart';
import '../themes/colors/grx_colors.dart';
import '../widgets/grx_toast_card.widget.dart';
import '../widgets/grx_toast_overlay.widget.dart';

abstract class GrxToastService {
  static BuildContext? _context;
  static OverlayEntry? _entry;

  static void init(BuildContext context) => _context = context;

  static void showError({
    required String message,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
    List<GrxToastAction>? actions,
  }) => _show(
    message: message,
    backgroundColor: GrxColors.error,
    title: title,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
    actions: actions,
  );

  static void showWarning({
    required String message,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
    List<GrxToastAction>? actions,
  }) => _show(
    message: message,
    backgroundColor: GrxColors.warning,
    title: title,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
    actions: actions,
  );

  static void showSuccess({
    required String message,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
    List<GrxToastAction>? actions,
  }) => _show(
    message: message,
    backgroundColor: GrxColors.success,
    title: title,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
    actions: actions,
  );

  static void _show({
    required String message,
    required Color backgroundColor,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
    List<GrxToastAction>? actions,
  }) {
    _validateContext(context);

    final milliseconds = clampDouble(
      (message.length * 100 +
          (title?.length ?? 0) * 100 +
          (actions?.length ?? 0) * 100),
      4000,
      double.infinity,
    ).toInt();

    final duration = toastDuration ?? Duration(milliseconds: milliseconds);
    final buildContext = (context ?? _context)!;

    _dropCurrent();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => GrxToastOverlay(
        duration: duration,
        autoDismiss: !permanent,
        onRemove: () => _remove(entry),
        child: GrxToastCard(
          message: message,
          title: title,
          actions: actions,
          color: backgroundColor,
          onClose: () => _remove(entry),
        ),
      ),
    );
    _entry = entry;
    Overlay.of(buildContext, rootOverlay: true).insert(entry);

    // After an async gap (e.g. API call), no frame may be scheduled, so the
    // toast stays invisible until the next user-driven frame.
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  static void _dropCurrent() {
    final current = _entry;
    _entry = null;
    if (current != null && current.mounted) {
      current.remove();
    }
  }

  static void _remove(OverlayEntry entry) {
    if (!entry.mounted) return;
    if (identical(_entry, entry)) _entry = null;
    entry.remove();
  }

  static void _validateContext(BuildContext? context) {
    if ((context ?? _context) == null) {
      throw PlatformException(
        code: 'missing_build_context',
        message:
            'The build context must be passed either in init or show method',
      );
    }
  }
}
