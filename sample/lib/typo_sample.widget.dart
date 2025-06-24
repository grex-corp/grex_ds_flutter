import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

class TypoSample extends StatelessWidget {
  const TypoSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GrxDisplayLargeText('Display Large Text'),
        GrxDisplayLargeText(
          'Display Large Text',
          isLoading: true,
        ),
        GrxDisplayText('Display Text'),
        GrxDisplayText(
          'Display Text', 
          isLoading: true,
        ),
        GrxDisplaySmallText('Display Small Text'),
        GrxDisplaySmallText(
          'Display Small Text',
          isLoading: true,
        ),
        GrxHeadlineLargeText('Headline Large Text'),
        GrxHeadlineLargeText(
          'Headline Large Text',
          isLoading: true,
        ),
        GrxHeadlineText('Headline Text'),
        GrxHeadlineText(
          'Headline Text',
          isLoading: true,
        ),
        GrxHeadlineText('Headline Medium Text'),
        GrxHeadlineText(
          'Headline Medium Text',
          isLoading: true,
        ),
        GrxHeadlineSmallText('Headline Small Text'),
        GrxHeadlineSmallText(
          'Headline Small Text',
          isLoading: true,
        ),
        GrxTitleLargeText('Title Large Text'),
        GrxTitleLargeText(
          'Title Large Text',
          isLoading: true,
        ),
        GrxTitleText('Title Text'),
        GrxTitleText(
          'Title Text',
          isLoading: true,
        ),
        GrxTitleSmallText('Title Small Text'),
        GrxTitleSmallText(
          'Title Small Text',
          isLoading: true,
        ),
        GrxBodyLargeText('Body Large Text'),
        GrxBodyLargeText(
          'Body Large Text',
          isLoading: true,
        ),
        GrxBodyText('Body Text'),
        GrxBodyText(
          'Body Text',
          isLoading: true,
        ),
        GrxBodySmallText('Body Small Text'),
        GrxBodySmallText(
          'Body Small Text',
          isLoading: true,
        ),
        GrxLabelLargeText('Label Large Text'),
        GrxLabelLargeText(
          'Label Large Text',
          isLoading: true,
        ),
        GrxLabelText('Label Text'),
        GrxLabelText(
          'Label Text',
          isLoading: true,
        ),
        GrxLabelSmallText('Label Small Text'),
        GrxLabelSmallText(
          'Label Small Text',
          isLoading: true,
        ),
      ],
    );
  }
}
