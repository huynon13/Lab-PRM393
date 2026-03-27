import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('full flow: add -> open detail -> edit -> save', (tester) async {
    // Arrange
    final repository = TaskRepository();
    await tester.pumpWidget(
      MaterialApp(home: TaskListScreen(repository: repository)),
    );

    // Add Original title
    await tester.enterText(
      find.byKey(const Key('addTaskField')),
      'Original title',
    );
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();
    expect(find.text('Original title'), findsOneWidget);

    // Tap task -> open detail
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);

    // Edit -> Updated title
    await tester.enterText(
      find.byKey(const Key('detailTitleField')),
      'Updated title',
    );

    // Save
    await tester.tap(find.byKey(const Key('saveTaskButton')));
    await tester.pumpAndSettle();

    // Verify list shows updated title
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}
