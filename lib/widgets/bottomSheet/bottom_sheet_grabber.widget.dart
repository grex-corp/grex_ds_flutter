import 'package:flutter/material.dart';

import '../../themes/colors/grx_colors.dart';
import '../typography/grx_headline_medium_text.widget.dart';

class BottomSheetGrabber extends StatefulWidget {
  const BottomSheetGrabber({super.key});

  @override
  State<StatefulWidget> createState() => _BottomSheetGrabberState();
}

class _BottomSheetGrabberState extends State<BottomSheetGrabber> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: GrxColors.cff83a6cf,
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
                decoration: const BoxDecoration(
                  color: GrxColors.cffffffff,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  ),
                ),
                height: 4,
                width: 30,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: const GrxHeadlineMediumText(
                  'Selecione uma opção',
                  color: GrxColors.cffffffff,
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
