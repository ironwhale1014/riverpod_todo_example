import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/screen/components/todo_edit_dialog.dart';
import 'package:drift_todo_train/screen/home_page.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoCard extends HookConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoWithCategory = ref.watch(currentTodoProvider);
    final todoEntry = todoWithCategory.todoEntry;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todoEntry.description,style: TextStyle(fontSize: 24),),
                    Text(
                      todoEntry.dueDate != null
                          ? dateFormat.format(todoEntry.dueDate!)
                          : 'not set due date',
                    ),
                  ],
                ),
              ),
              IconButton(
                color: Colors.red,
                onPressed: () async {
                  await ref
                      .read(todoServiceProvider.notifier)
                      .deleteTodo(todo: todoEntry);
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => TodoEditDialog(todoEntry: todoEntry),
                ),
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
