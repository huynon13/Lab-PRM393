import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('integration folder flow smoke test', (tester) async {
    final repository = TaskRepository();
    await tester.pumpWidget(
      MaterialApp(home: TaskListScreen(repository: repository)),
    );

    await tester.enterText(find.byKey(const Key('addTaskField')), 'Task X');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    expect(find.text('Task X'), findsOneWidget);
  });
}
