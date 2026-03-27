import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

Widget _buildScreen(TaskRepository repository) {
  return MaterialApp(home: TaskListScreen(repository: repository));
}

void main() {
  group('TaskListScreen widget tests', () {
    testWidgets('shows empty state text when no tasks', (tester) async {
      // Arrange
      final repository = TaskRepository();

      // Act
      await tester.pumpWidget(_buildScreen(repository));

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('adds one task from input', (tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(_buildScreen(repository));

      // Act
      await tester.enterText(find.byKey(const Key('addTaskField')), 'Buy milk');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert
      expect(find.text('Buy milk'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('shows multiple added tasks', (tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(_buildScreen(repository));

      // Act
      await tester.enterText(find.byKey(const Key('addTaskField')), 'Task 1');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      await tester.enterText(find.byKey(const Key('addTaskField')), 'Task 2');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });
  });
}
