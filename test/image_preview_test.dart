import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grex_ds/pages/image_preview.page.dart';
import 'package:grex_ds/themes/icons/grx_icons.dart';

final Uint8List _png = Uint8List.fromList(const <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x02,
  0x00,
  0x00,
  0x00,
  0x90,
  0x77,
  0x53,
  0xDE,
  0x00,
  0x00,
  0x00,
  0x0C,
  0x49,
  0x44,
  0x41,
  0x54,
  0x08,
  0xD7,
  0x63,
  0xF8,
  0xCF,
  0xC0,
  0x00,
  0x00,
  0x00,
  0x03,
  0x00,
  0x01,
  0x00,
  0x05,
  0xFE,
  0x02,
  0xFE,
  0xDC,
  0xCC,
  0x59,
  0xE7,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openPreview(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      ImagePreview.route(
                        image: MemoryImage(_png),
                        title: 'Preview',
                        sourceRect: () => const Rect.fromLTWH(20, 40, 48, 48),
                      ),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> settleDismiss(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
  }

  testWidgets('drag down dismisses the preview', (tester) async {
    await openPreview(tester);
    expect(find.text('Preview'), findsOneWidget);

    await tester.drag(find.byType(ImagePreview), const Offset(0, 240));
    await settleDismiss(tester);

    expect(find.text('Preview'), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('drag sideways dismisses the preview', (tester) async {
    await openPreview(tester);

    await tester.drag(find.byType(ImagePreview), const Offset(-240, 20));
    await settleDismiss(tester);

    expect(find.text('Preview'), findsNothing);
  });

  testWidgets('a short drag springs the image back', (tester) async {
    await openPreview(tester);

    await tester.timedDrag(
      find.byType(ImagePreview),
      const Offset(0, 30),
      const Duration(milliseconds: 800),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Preview'), findsOneWidget);
  });

  testWidgets('close button plays the dismiss animation', (tester) async {
    await openPreview(tester);

    await tester.tap(find.byIcon(GrxIcons.close_m));
    await settleDismiss(tester);

    expect(find.text('Preview'), findsNothing);
  });
}
