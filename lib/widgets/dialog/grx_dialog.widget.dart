import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/radius/grx_radius.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../buttons/grx_close_button.widget.dart';
import '../typography/grx_body_text.widget.dart';
import '../typography/grx_title_large_text.widget.dart';

class GrxDialog extends StatelessWidget {
  const GrxDialog({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.actions = const [],
    this.actionsAlignment = MainAxisAlignment.end,
    this.showCloseButton = true,
    this.onClose,
    this.insetPadding,
    this.maxWidth = 400,
  });

  final String title;
  final String? description;
  final Widget? content;
  final List<Widget> actions;
  final MainAxisAlignment actionsAlignment;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final EdgeInsets? insetPadding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: GrxColors.neutrals,
      elevation: 8,
      shadowColor: GrxColors.neutrals.shade1000.withValues(alpha: 0.12),
      insetPadding:
          insetPadding ?? const EdgeInsets.symmetric(horizontal: GrxSpacing.m),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GrxRadius.ml),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(GrxSpacing.ml),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: GrxSpacing.s,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: GrxSpacing.xxs,
                      children: [
                        GrxTitleLargeText(
                          title,
                          color: GrxColors.neutrals.shade1000,
                        ),
                        if (description != null)
                          GrxBodyText(
                            description!,
                            color: GrxColors.neutrals.shade700,
                            overflow: TextOverflow.visible,
                          ),
                      ],
                    ),
                  ),
                  if (showCloseButton)
                    GrxCloseButton(
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                    ),
                ],
              ),
              if (content != null) ...[
                const SizedBox(height: GrxSpacing.ml),
                content!,
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: GrxSpacing.ml),
                Row(
                  mainAxisAlignment: actionsAlignment,
                  spacing: GrxSpacing.s,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
