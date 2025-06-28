import 'package:drift_todo_train/database/todo_service.dart';
import 'package:drift_todo_train/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/util/date_util.dart';
import 'todo_edit_dialog.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoWithCategory = ref.watch(currentTodo);
    final todo = todoWithCategory.todoEntry;
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(todo.description), getDateFormat(todo.dueDate)],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text("NO"),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(todoServiceProvider.notifier)
                              .todoDelete(todo);
                          context.pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => TodoEditDialog(todo),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
