import 'package:drift_todo_train/screen/components/todo_edit_dialog.dart';
import 'package:drift_todo_train/screen/home_page.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final _formattedDate = DateFormat.yMMMd();

class TodoCard extends ConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodo);
    final dueDate = todo.todoEntry.dueDate;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(todo.todoEntry.description),
                  if (dueDate != null) Text(_formattedDate.format(dueDate)),
                  if (dueDate == null)
                    Text(
                      'No due date set',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TodoEditDialog(todoEntry: todo.todoEntry);
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              color: Colors.red,
              onPressed: () {
                ref
                    .read(todoServiceProvider.notifier)
                    .deleteTodo(todo: todo.todoEntry);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
