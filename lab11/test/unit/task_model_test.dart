import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task model', () {
    test('completed defaults to false', () {
      // Arrange
      final task = Task(id: '1', title: 'Read docs');

      // Assert
      expect(task.completed, isFalse);
    });

    test('toggle switches completed value', () {
      // Arrange
      final task = Task(id: '1', title: 'Read docs');

      // Act
      final toggledOnce = task.toggle();
      final toggledTwice = toggledOnce.toggle();

      // Assert
      expect(toggledOnce.completed, isTrue);
      expect(toggledTwice.completed, isFalse);
    });
  });
}
