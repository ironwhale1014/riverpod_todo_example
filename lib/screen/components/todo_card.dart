import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/edit_dialog.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard(this.todoWithCategory, {super.key});

  final TodoWithCategory todoWithCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TodoEntry todoEntry = todoWithCategory.todoEntry;

    return InkWell(
      onTap: () {
        ref.read(todoServiceProvider.notifier).toggle(todoEntry);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(

          color: todoEntry.isComplete ? Colors.greenAccent : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todoEntry.description,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        todoEntry.dueDate != null
                            ? dateTransfer(todoEntry.dueDate!)
                            : 'not set dueDate',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(todoServiceProvider.notifier).delete(todoEntry);
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => EditDialog( todoEntry),
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
