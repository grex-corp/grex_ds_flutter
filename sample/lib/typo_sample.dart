import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

class TypoSample extends StatelessWidget {
  const TypoSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        GrxHeadlineLargeText('Healine Large Text'),
        GrxHeadlineLargeText(
          'Healine Large Text',
          isLoading: true,
        ),
        GrxHeadlineText('Headline Text'),
        GrxHeadlineText(
          'Headline Text',
          isLoading: true,
        ),
        GrxHeadlineMediumText('Headline Medium Text'),
        GrxHeadlineMediumText(
          'Headline Medium Text',
          isLoading: true,
        ),
        GrxHeadlineSmallText('Headline Small Text'),
        GrxHeadlineSmallText(
          'Headline Small Text',
          isLoading: true,
        ),
        GrxBodyText('Body Text'),
        GrxBodyText(
          'Body Text',
          isLoading: true,
        ),
        GrxCaptionLargeText('Caption Large Text'),
        GrxCaptionLargeText(
          'Caption Large Text',
          isLoading: true,
        ),
        GrxCaptionText('Caption Text'),
        GrxCaptionText(
          'Caption Text',
          isLoading: true,
        ),
        GrxCaptionSmallText('Caption Small Text'),
        GrxCaptionSmallText(
          'Caption Small Text',
          isLoading: true,
        ),
        GrxOverlineText('Overline Text'),
        GrxOverlineText(
          'Overline Text',
          isLoading: true,
        ),
      ],
    );
  }
}
