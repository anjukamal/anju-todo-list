
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:todo_task_management/models/auth_provider.dart';
import 'package:todo_task_management/models/task_provider.dart';
import 'package:todo_task_management/screens/login_screen.dart';
import 'package:todo_task_management/screens/task_form_screen.dart';
import 'package:todo_task_management/task_list_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final taskProvider = context.watch<TaskProvider>();

    if (authProvider.user == null) {
      return const LoginScreen();
    }

    taskProvider.loadTasks(authProvider.user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(taskProvider.errorMessage!)),
              );
            });
          }
          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text('No tasks found. Add a new task!'));
          }
          return RefreshIndicator(
            onRefresh: () => taskProvider.loadTasks(authProvider.user!.uid),
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    taskProvider.deleteTask(task.id, authProvider.user!.uid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${task.title} deleted')),
                    );
                  },
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (context, _) => TaskFormScreen(task: task),
                    closedBuilder: (context, openContainer) => TaskListItem(
                      task: task,
                      onTap: openContainer,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
