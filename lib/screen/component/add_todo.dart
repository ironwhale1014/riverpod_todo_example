import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void showAddTodoDialog(BuildContext context, [TodoModel? todo]) {
  showDialog(context: context, builder: (context) => AddTodoDialog(todo));
}

class AddTodoDialog extends HookConsumerWidget {
  const AddTodoDialog(this.todo, {super.key});

  final TodoModel? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptionController = useTextEditingController();
    if (todo != null) {
      descriptionController.text = todo!.description;
    }

    return AlertDialog(
      title: Text('Add Todo', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [TextField(controller: descriptionController)],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (todo != null) {
              ref
                  .read(todoServiceProvider.notifier)
                  .update(
                    todo!.copyWith(
                      description: descriptionController.text.trim(),
                    ),
                  );
            } else {
              ref
                  .read(todoServiceProvider.notifier)
                  .save(descriptionController.text.trim());
            }

            context.pop();
          },
          child: Text('ok'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
