import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../themes/colors/grx_colors.dart';
import '../themes/icons/grx_icons.dart';
import '../widgets/buttons/grx_icon_button.widget.dart';
import '../widgets/typography/grx_caption_large_text.widget.dart';
import '../widgets/typography/grx_headline_small_text.widget.dart';

abstract class GrxToastService {
  static BuildContext? _context;

  static void init(BuildContext context) => _context = context;

  static void showError({
    required String message,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
  }) =>
      _show(
        message: message,
        icon: _getIcon(GrxIcons.cancel),
        backgroundColor: GrxColors.cffffa5a5,
        title: title,
        toastDuration: toastDuration,
        context: context,
      );

  static void showWarning({
    required String message,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
  }) =>
      _show(
        message: message,
        icon: _getIcon(GrxIcons.warning_amber),
        backgroundColor: GrxColors.fffff6a8,
        title: title,
        toastDuration: toastDuration,
        context: context,
      );

  static void showSuccess({
    required String message,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
  }) =>
      _show(
        message: message,
        icon: _getIcon(GrxIcons.check_circle_outline),
        backgroundColor: GrxColors.cff90e6bc,
        title: title,
        toastDuration: toastDuration,
        context: context,
      );

  static void _show({
    required String message,
    required Icon icon,
    required Color backgroundColor,
    String? title,
    Duration? toastDuration,
    BuildContext? context,
  }) {
    _validateContext(context);

    int milliseconds = (message.length * 100 + (title?.length ?? 0) * 100);

    if (milliseconds <= 3000) {
      milliseconds = 3000;
    }

    final duration = toastDuration ??
        Duration(
          milliseconds: milliseconds,
        );

    final buildContext = (context ?? _context)!;

    Flushbar(
      titleText: (title?.isNotEmpty ?? false)
          ? GrxHeadlineSmallText(
              title!,
              color: GrxColors.cff202c44,
            )
          : null,
      messageText: GrxCaptionLargeText(
        message,
        color: GrxColors.cff202c44,
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: backgroundColor,
      mainButton: GrxIconButton(
        icon: GrxIcons.close,
        color: GrxColors.cff202c44,
        onPressed: Navigator.of(buildContext).pop,
      ),
      shouldIconPulse: false,
      padding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 16.0,
      ),
      icon: icon,
      duration: duration,
    ).show(buildContext);
  }

  static Icon _getIcon(IconData data) => Icon(
        data,
        size: 24.0,
        color: GrxColors.cff202c44,
      );

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
