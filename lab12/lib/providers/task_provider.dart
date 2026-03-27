import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({List<Task>? initialTasks})
      : _tasks = List<Task>.from(initialTasks ?? const <Task>[]);

  factory TaskProvider.seed() {
    return TaskProvider(initialTasks: const <Task>[
      Task(id: 'task-1', title: 'Read Flutter performance docs'),
      Task(id: 'task-2', title: 'Optimize list rebuilds'),
      Task(id: 'task-3', title: 'Create release build'),
    ]);
  }

  final List<Task> _tasks;
  int _nextId = 4;

  List<Task> get tasks => List<Task>.unmodifiable(_tasks);

  void addTask(String title) {
    final String trimmed = title.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _tasks.add(Task(id: 'task-${_nextId++}', title: trimmed));
    notifyListeners();
  }

  void toggleTask(String id) {
    final int index = _tasks.indexWhere((Task task) => task.id == id);
    if (index == -1) {
      return;
    }
    final Task task = _tasks[index];
    _tasks[index] = task.copyWith(isDone: !task.isDone);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((Task task) => task.id == id);
    notifyListeners();
  }
}
