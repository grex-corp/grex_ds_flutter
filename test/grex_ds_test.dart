import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grex_ds/grex_ds.dart';

void main() {
  group('GrxUserAvatar Tests', () {
    testWidgets('should show remove button when image is present and editable', (WidgetTester tester) async {
      bool removeCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GrxUserAvatar(
              radius: 25,
              editable: true,
              imageFile: File('test_image.jpg'),
              onRemoveAvatar: () {
                removeCalled = true;
              },
            ),
          ),
        ),
      );

      // Verify the remove button is visible
      expect(find.byIcon(GrxIcons.close_l), findsOneWidget);
      
      // Tap the remove button
      await tester.tap(find.byIcon(GrxIcons.close_l));
      await tester.pump();
      
      // Verify the callback was called
      expect(removeCalled, isTrue);
    });

    testWidgets('should not show remove button when no image is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GrxUserAvatar(
              radius: 25,
              editable: true,
              text: 'Test User',
              onRemoveAvatar: () {},
            ),
          ),
        ),
      );

      // Verify the remove button is not visible
      expect(find.byIcon(GrxIcons.close_l), findsNothing);
    });

    testWidgets('should not show remove button when not editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GrxUserAvatar(
              radius: 25,
              editable: false,
              imageFile: File('test_image.jpg'),
              onRemoveAvatar: () {},
            ),
          ),
        ),
      );

      // Verify the remove button is not visible
      expect(find.byIcon(GrxIcons.close_l), findsNothing);
    });

    testWidgets('should show camera button when editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GrxUserAvatar(
              radius: 25,
              editable: true,
              text: 'Test User',
            ),
          ),
        ),
      );

      // Verify the camera button is visible
      expect(find.byIcon(GrxIcons.camera), findsOneWidget);
    });

    testWidgets('should not show camera button when not editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GrxUserAvatar(
              radius: 25,
              editable: false,
              text: 'Test User',
            ),
          ),
        ),
      );

      // Verify the camera button is not visible
      expect(find.byIcon(GrxIcons.camera), findsNothing);
    });
  });
}
