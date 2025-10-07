import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../../themes/radius/grx_radius.dart';
import '../../themes/spacing/grx_spacing.dart';
import '../typography/grx_title_large_text.widget.dart';

class GrxBottomSheetGrabber extends StatefulWidget {
  const GrxBottomSheetGrabber({super.key, this.title});

  final String? title;

  @override
  State<StatefulWidget> createState() => _GrxBottomSheetGrabberState();
}

class _GrxBottomSheetGrabberState extends State<GrxBottomSheetGrabber> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: GrxColors.neutrals,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: GrxSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: GrxSpacing.m,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: GrxColors.neutrals.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(GrxRadius.xxs),
                  ),
                ),
                height: 4,
                width: 32.0,
              ),
              if (widget.title != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: GrxSpacing.m),
                  child: GrxTitleLargeText(
                    widget.title!,
                    color: GrxColors.neutrals.shade1000,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
