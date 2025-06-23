import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../themes/colors/grx_colors.dart';
import '../themes/icons/grx_icons.dart';
import '../widgets/buttons/grx_icon_button.widget.dart';
import '../widgets/typography/grx_label_large_text.widget.dart';
import '../widgets/typography/grx_headline_small_text.widget.dart';

abstract class GrxToastService {
  static BuildContext? _context;

  static void init(BuildContext context) => _context = context;

  static void showError({
    required String title,
    String? subtitle,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
  }) => _show(
    title: title,
    icon: _getIcon(GrxIcons.cancel),
    backgroundColor: GrxColors.error,
    subtitle: subtitle,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
  );

  static void showWarning({
    required String title,
    String? subtitle,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
  }) => _show(
    title: title,
    icon: _getIcon(GrxIcons.warning_amber),
    backgroundColor: GrxColors.warning,
    subtitle: subtitle,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
  );

  static void showSuccess({
    required String title,
    String? subtitle,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
  }) => _show(
    title: title,
    icon: _getIcon(GrxIcons.check_circle_outline),
    backgroundColor: GrxColors.success,
    subtitle: subtitle,
    toastDuration: toastDuration,
    context: context,
    permanent: permanent,
  );

  static void _show({
    required String title,
    required Icon icon,
    required Color backgroundColor,
    String? subtitle,
    Duration? toastDuration,
    BuildContext? context,
    bool permanent = false,
  }) {
    _validateContext(context);

    int milliseconds = (title.length * 100 + (subtitle?.length ?? 0) * 100);

    if (milliseconds <= 3000) {
      milliseconds = 3000;
    }

    final duration = toastDuration ?? Duration(milliseconds: milliseconds);

    final buildContext = (context ?? _context)!;

    // Flushbar(
    //   titleText: (title?.isNotEmpty ?? false)
    //       ? GrxHeadlineSmallText(
    //           title!,
    //           color: GrxColors.cff202c44,
    //         )
    //       : null,
    //   messageText: GrxLabelLargeText(
    //     message,
    //     color: GrxColors.cff202c44,
    //   ),
    //   flushbarPosition: FlushbarPosition.BOTTOM,
    //   flushbarStyle: FlushbarStyle.GROUNDED,
    //   backgroundColor: backgroundColor,
    //   mainButton: GrxIconButton(
    //     icon: GrxIcons.close,
    //     color: GrxColors.cff202c44,
    //     onPressed: Navigator.of(buildContext).pop,
    //   ),
    //   shouldIconPulse: false,
    //   padding: const EdgeInsets.symmetric(
    //     vertical: 18.0,
    //     horizontal: 16.0,
    //   ),
    //   icon: icon,
    //   duration: duration,
    // ).show(buildContext);

    DelightToastBar? toast;

    toast = DelightToastBar(
      autoDismiss: !permanent,
      snackbarDuration:
          permanent ? const Duration(milliseconds: 5000) : duration,
      builder:
          (context) => ToastCard(
            leading: icon,
            title: GrxLabelLargeText(
              title,
              color: GrxColors.primary.shade900,
              overflow: TextOverflow.visible,
            ),
            subtitle:
                (subtitle?.isNotEmpty ?? false)
                    ? GrxHeadlineSmallText(
                      subtitle!,
                      color: GrxColors.primary.shade900,
                      overflow: TextOverflow.visible,
                    )
                    : null,
            trailing: GrxIconButton(
              icon: GrxIcons.close,
              color: GrxColors.primary.shade900,
              onPressed: () => toast?.remove(),
            ),
            color: backgroundColor,
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
