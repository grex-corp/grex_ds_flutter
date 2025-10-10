import 'dart:ui';

import 'package:delightful_toast/delight_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/grx_toast_action.model.dart';
import '../themes/colors/grx_colors.dart';
import '../themes/icons/grx_icons.dart';
import '../widgets/grx_toast_card.widget.dart';

abstract class GrxToastService {
  static BuildContext? _context;

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
    icon: _getIcon(GrxIcons.cancel),
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
    icon: _getIcon(GrxIcons.warning_amber),
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
    icon: _getIcon(GrxIcons.check_circle_outline),
    backgroundColor: GrxColors.success,
    title: title,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
    actions: actions,
  );

  static void _show({
    required String message,
    required Icon icon,
    required Color backgroundColor,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
    List<GrxToastAction>? actions,
  }) {
    _validateContext(context);

    final milliseconds =
        clampDouble(
          (message.length * 100 +
              (title?.length ?? 0) * 100 +
              (actions?.length ?? 0) * 100),
          4000,
          double.infinity,
        ).toInt();

    final duration = toastDuration ?? Duration(milliseconds: milliseconds);

    final buildContext = (context ?? _context)!;

    DelightToastBar? toast;

    toast = DelightToastBar(
      autoDismiss: !permanent,
      snackbarDuration: duration,
      builder:
          (context) => GrxToastCard(
            message: message,
            title: title,
            actions: actions,
            color: backgroundColor,
            onClose: () => toast?.remove(),
          ),
    )..show(buildContext);
  }

  static Icon _getIcon(IconData data) =>
      Icon(data, size: 24.0, color: GrxColors.primary.shade900);

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
