// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_journal_app/main.dart';

void main() {
  testWidgets('Daily Journal App basic structure test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DailyJournalApp());

    // Verify that the app has the correct title
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, equals('Daily Journal'));

    // Verify that debug banner is disabled
    expect(app.debugShowCheckedModeBanner, isFalse);

    // Verify that the app has a home route
    expect(app.home, isNotNull);
  });

  testWidgets('App theme configuration test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DailyJournalApp());

    // Verify that the app has Material 3 enabled
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme?.useMaterial3, isTrue);

    // Verify that the app has routes configured
    expect(app.routes, isNotNull);
    expect(app.routes!.length, greaterThan(0));
  });
}
