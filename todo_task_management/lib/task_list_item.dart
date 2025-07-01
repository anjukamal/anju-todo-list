import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_task_management/models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListItem({Key? key, required this.task, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.done
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description.isEmpty ? 'No description' : task.description),
            Text('Due: ${DateFormat.yMMMd().format(task.dueDate)}'),
          ],
        ),
        trailing: Chip(
          label: Text(task.priority.toString().split('.').last),
          backgroundColor: task.priority == TaskPriority.high
              ? Colors.red[100]
              : task.priority == TaskPriority.medium
                  ? Colors.yellow[100]
                  : Colors.green[100],
        ),
      ),
    );
  }
}
