import 'package:flutter/material.dart';

import '../models/grx_toast_action.model.dart';
import '../themes/colors/grx_colors.dart';
import '../themes/spacing/grx_spacing.dart';
import 'buttons/grx_close_button.widget.dart';
import 'buttons/grx_tertiary_button.widget.dart';
import 'typography/grx_label_large_text.widget.dart';
import 'typography/grx_title_text.widget.dart';

class GrxToastCard extends StatelessWidget {
  const GrxToastCard({
    super.key,
    required this.message,
    this.title,
    this.actions,
    this.color,
    this.shadowColor,
    this.onClose,
  });

  final String message;
  final String? title;
  final List<GrxToastAction>? actions;
  final Color? color;
  final Color? shadowColor;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color ?? GrxColors.neutrals,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset.zero,
            color: shadowColor ?? Colors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: GrxSpacing.s,
            right: GrxSpacing.s,
            child: Padding(
              padding: const EdgeInsets.all(GrxSpacing.xxs),
              child: GrxCloseButton(onPressed: onClose),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(GrxSpacing.ml),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: GrxSpacing.xxs,
              children: [
                if (title != null)
                  GrxTitleText(title, color: GrxColors.primary.shade900),
                GrxLabelLargeText(
                  message,
                  color: GrxColors.primary.shade900,
                  overflow: TextOverflow.visible,
                ),
                if (actions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: GrxSpacing.s),
                    child: Row(
                      spacing: GrxSpacing.xs,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:
                          actions!
                              .map(
                                (action) => GrxTertiaryButton(
                                  text: action.label,
                                  icon: action.icon,
                                  foregroundColor: GrxColors.primary.shade900,
                                  padding: EdgeInsets.zero,
                                  onPressed: action.onPressed,
                                ),
                              )
                              .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
