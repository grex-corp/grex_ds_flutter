import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/colors/grx_colors.dart';
import '../themes/typography/styles/grx_caption_large_text.style.dart';

/// An utility class that has methods related to likified texts.
abstract class GrxLinkify {
  static List<InlineSpan> plainText({
    required String text,
    TextStyle? defaultStyle,
    Color? linkColor,
  }) {
    return textSpan(
      textSpan: TextSpan(text: text),
      defaultStyle: defaultStyle,
      linkColor: linkColor,
    );
  }

  static List<InlineSpan> textSpan({
    required InlineSpan textSpan,
    TextStyle? defaultStyle,
    Color? linkColor,
  }) {
    final List<InlineSpan> formattedText = [];

    textSpan.visitChildren(
      (child) {
        final String? spanText = (child as TextSpan).text;
        final TextStyle? spanStyle = (child.style ?? defaultStyle);
        final TextStyle? linkStyle = spanStyle?.copyWith(
          color: linkColor,
          decoration: TextDecoration.underline,
        );

        if (spanText?.isNotEmpty ?? false) {
          final List<LinkifyElement> elements = linkify(
            spanText!,
          );

          for (final element in elements) {
            if (element is TextElement) {
              formattedText.add(
                TextSpan(
                  text: element.text,
                  style: spanStyle,
                ),
              );
            } else {
              late final Uri? url;
              late final String text;

              if (element is UrlElement) {
                text = element.url;
                url = Uri.tryParse(element.url);
              } else if (element is EmailElement) {
                text = element.emailAddress;
                url = Uri.tryParse(element.url);
              }

              formattedText.add(
                TextSpan(
                  text: text,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      bool hasLaunched = false;

                      if (url != null) {
                        hasLaunched = await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }

                      if (!hasLaunched) {
                        throw 'Não abriu a url';
                        //TODO: toast
                      }
                    },
                ),
              );
            }
          }
        }
        return true;
      },
    );

    return formattedText;
  }

  static Uri getFirstUrlFromText(final String text) {
    final List<LinkifyElement> elements = linkify(
      text,
      linkifiers: const [
        UrlLinkifier(),
      ],
    );

    final LinkifyElement firstUrlElement = elements.firstWhere(
      (element) {
        if (element is UrlElement) {
          return Uri.tryParse(element.url) != null;
        }

        return false;
      },
      orElse: () => UrlElement(''),
    );

    return Uri.parse((firstUrlElement as UrlElement).url);
  }

  static InlineSpan buildLink({
    required final String text,
    required final String link,
  }) {
    final uri = Uri.parse(link);

    return TextSpan(
      text: text,
      style: const GrxCaptionLargeTextStyle(
        decoration: TextDecoration.underline,
        color: GrxColors.cff5c95e4,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunchUrl(uri)) {
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          }
        },
    );
  }
}
