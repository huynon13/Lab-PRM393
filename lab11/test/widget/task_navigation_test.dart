import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('navigates from list to task detail screen', (tester) async {
    // Arrange
    final repository = TaskRepository();
    repository.addTask('Seeded task');

    await tester.pumpWidget(
      MaterialApp(home: TaskListScreen(repository: repository)),
    );

    // Act
    await tester.tap(find.text('Seeded task'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}
