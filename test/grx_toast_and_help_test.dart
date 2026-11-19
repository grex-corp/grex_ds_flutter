import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grex_ds/grex_ds.dart';
import 'package:material_ui/material_ui.dart';

void _expectNoFallbackUnderline(WidgetTester tester, String text) {
  final style = tester
      .renderObject<RenderParagraph>(find.text(text))
      .text
      .style;
  expect(style?.decoration, isNot(TextDecoration.underline));
  expect(style?.decorationColor, isNot(const Color(0xFFFFFF00)));
}

void main() {
  testWidgets('toast shows the message and closes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () => GrxToastService.showSuccess(
                  context: context,
                  message: 'Salvo',
                  toastDuration: const Duration(seconds: 5),
                ),
                child: const Text('go'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Salvo'), findsOneWidget);
    _expectNoFallbackUnderline(tester, 'Salvo');

    await tester.tap(find.byIcon(GrxIcons.close_m));
    await tester.pump();

    expect(find.text('Salvo'), findsNothing);
  });

  testWidgets('a leaving toast can be replaced', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: TextButton(
                  onPressed: () => GrxToastService.showSuccess(
                    context: context,
                    message: 'Salvo',
                    toastDuration: const Duration(milliseconds: 500),
                  ),
                  child: const Text('go'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('go'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Salvo'), findsOneWidget);
  });

  testWidgets('showing a toast after the overlay is gone does not throw', (
    tester,
  ) async {
    var generation = 0;
    late void Function(void Function()) rebuild;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return MaterialApp(
            key: ValueKey(generation),
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: TextButton(
                    onPressed: () => GrxToastService.showSuccess(
                      context: context,
                      message: 'Salvo',
                      toastDuration: const Duration(seconds: 5),
                    ),
                    child: const Text('go'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    rebuild(() => generation++);
    await tester.pump();
    await tester.tap(find.text('go'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Salvo'), findsOneWidget);
  });

  testWidgets('help popover shows the text and closes from the barrier', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: GrxHelpWidget(text: 'Ajuda'),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(GrxIcons.circle_info));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ajuda'), findsOneWidget);
    _expectNoFallbackUnderline(tester, 'Ajuda');

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('Ajuda'), findsNothing);
  });

  testWidgets('back closes the help popover and leaves the page', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: GrxHelpWidget(text: 'Ajuda')),
      ),
    );

    await tester.tap(find.byIcon(GrxIcons.circle_info));
    await tester.pumpAndSettle();
    expect(find.text('Ajuda'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    expect(find.text('Ajuda'), findsNothing);
    expect(find.byIcon(GrxIcons.circle_info), findsOneWidget);
  });

  testWidgets('help popover opens downward when the icon is at the top', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: GrxHelpWidget(text: 'Ajuda'),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(GrxIcons.circle_info));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Ajuda')).dy,
      greaterThanOrEqualTo(
        tester.getBottomLeft(find.byIcon(GrxIcons.circle_info)).dy,
      ),
    );
  });
}
