import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/screen/components/custom_dialog.dart';
import 'package:drift_todo_train/screen/home_page.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoWithCategory = ref.watch(currentTodoWithCategory);
    final todoEntry = todoWithCategory.todoEntry;
    final category = todoWithCategory.category;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todoEntry.description, style: TextStyle(fontSize: 24)),
                Text(
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  todoEntry.dueDate != null
                      ? dateFormat.format(todoEntry.dueDate!)
                      : 'not set due date',
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CustomDialog.withBtn(
                    title: 'Delete it??',
                    leftBtnOnPressed: () {
                      context.pop();
                    },
                    rightBtnOnPressed: () async {
                      context.pop();
                      await ref
                          .read(todoServiceProvider.notifier)
                          .deleteTodo(todoEntry);
                    },
                  ),
                );
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
