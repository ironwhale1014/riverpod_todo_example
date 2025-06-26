import 'package:drift_todo_train/common/util/date_util.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:drift_todo_train/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_dialog.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoWithCategory = ref.watch(currentTodo);
    final todoEntry = todoWithCategory.todoEntry;
    final category = todoWithCategory.category;
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todoEntry.description),
            if (todoEntry.dueDate != null)
              Text(dateFormat.format(todoEntry.dueDate!)),
            if (todoEntry.dueDate == null) Text('not set due date'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.red,
              onPressed: () async {
                final isConfirm = await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    title: 'Delete it',
                    onLeftBtnClick: () {
                      context.pop(false);
                    },
                    onRightBtnClick: () {
                      context.pop(true);
                    },
                  ),
                );
                if (isConfirm) {
                  ref.read(todoServiceProvider.notifier).todoDelete(todoEntry);
                }
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
