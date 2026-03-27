import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _isImagePrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isImagePrecached) {
      return;
    }
    precacheImage(const AssetImage('assets/images/task_icon.png'), context);
    _isImagePrecached = true;
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              context.read<TaskProvider>().addTask(controller.text);
              Navigator.of(dialogContext).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                context.read<TaskProvider>().addTask(controller.text);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalCount = context.select<TaskProvider, int>(
      (TaskProvider provider) => provider.tasks.length,
    );
    final int doneCount = context.select<TaskProvider, int>(
      (TaskProvider provider) =>
          provider.tasks.where((Task task) => task.isDone).length,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/images/task_icon.png'),
          ),
          const SizedBox(height: 8),
          Text(
            '$doneCount / $totalCount completed',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Divider(height: 24),
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (_, TaskProvider provider) => provider.tasks,
              builder: (BuildContext context, List<Task> tasks, _) {
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks yet. Tap + to add one.'),
                  );
                }

                return ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final Task task = tasks[index];
                    return TaskTile(
                      key: ValueKey<String>(task.id),
                      task: task,
                      onChanged: (_) =>
                          context.read<TaskProvider>().toggleTask(task.id),
                      onDelete: () =>
                          context.read<TaskProvider>().deleteTask(task.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
