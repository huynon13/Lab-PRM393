import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  group('TaskRepository', () {
    test('addTask adds a new task', () {
      // Arrange
      final repository = TaskRepository();

      // Act
      repository.addTask('Task A');

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Task A');
    });

    test('deleteTask removes an existing task', () {
      // Arrange
      final repository = TaskRepository();
      repository.addTask('Task A');
      final taskId = repository.tasks.first.id;

      // Act
      repository.deleteTask(taskId);

      // Assert
      expect(repository.tasks, isEmpty);
    });

    test('updateTask updates title of existing task', () {
      // Arrange
      final repository = TaskRepository();
      repository.addTask('Old title');
      final originalTask = repository.tasks.first;
      final updatedTask = Task(
        id: originalTask.id,
        title: 'New title',
        completed: originalTask.completed,
      );

      // Act
      repository.updateTask(updatedTask);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'New title');
    });
  });
}
