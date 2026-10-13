import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grex_ds/grex_ds.dart';

Future<void> _openPicker(
  WidgetTester tester, {
  required DateTime value,
  required bool futureDate,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GrxDateTimePickerFormField(
          labelText: 'Date',
          value: value,
          futureDate: futureDate,
        ),
      ),
    ),
  );

  await tester.tap(find.byType(TextField));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('opens when a future-only date is already in the past', (
    tester,
  ) async {
    await _openPicker(tester, value: DateTime(2020, 1, 1), futureDate: true);

    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('opens when a past-only date is already in the future', (
    tester,
  ) async {
    await _openPicker(tester, value: DateTime(2090, 1, 1), futureDate: false);

    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
