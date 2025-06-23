import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../typography/grx_headline_text.widget.dart';

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
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: GrxColors.neutrals.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                height: 4,
                width: 30,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: GrxHeadlineText(
                  widget.title ?? 'Selecione uma Opção',
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
