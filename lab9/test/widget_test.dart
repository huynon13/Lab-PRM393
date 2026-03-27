// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:lab9/main.dart';

void main() {
  testWidgets('Home menu renders and navigates', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lab 9 - Local JSON Storage'), findsOneWidget);
    expect(find.text('Lab 9.1 - Read JSON from assets'), findsOneWidget);
    expect(find.text('Lab 9.2 - Save & Load JSON (device storage)'), findsOneWidget);
    expect(find.text('Lab 9.3 - CRUD + Search (auto-save)'), findsOneWidget);

    await tester.tap(find.text('Lab 9.1 - Read JSON from assets'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Lab 9.1 - Read JSON From Assets'), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(
      find.text('Lab 9.3 - CRUD + Search (auto-save)'),
      warnIfMissed: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Lab 9.3 - JSON CRUD + Search (Auto-save)'), findsOneWidget);
  });
}
