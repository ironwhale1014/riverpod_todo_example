import 'package:drift_todo_train/common/ui/component/custom_dialog.dart';
import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard(this.model, {super.key});

  final TodoModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Text(model.description),
      subtitle: Text(
        model.dueDate != null
            ? getDateToString(model.dueDate!)
            : "pick due Date",
      ),
      trailing: IconButton(
        onPressed: () {
          showCustomConfirmDialog(
            context: context,
            title: 'delete todo',
            content: Text('delete it?', textAlign: TextAlign.center),
            onConfirm: () {
              ref.read(todoServiceProvider.notifier).delete(model);
              context.pop();
            },
          );
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}
