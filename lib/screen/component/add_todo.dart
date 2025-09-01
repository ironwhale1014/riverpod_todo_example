import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void showAddTodoDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => const AddTodoDialog());
}

class AddTodoDialog extends HookConsumerWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptionController = useTextEditingController();

    return AlertDialog(
      title: Text('Add Todo', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [TextField(controller: descriptionController)],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref
                .read(todoServiceProvider.notifier)
                .save(descriptionController.text.trim());
            context.pop();
          },
          child: Text('ok'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
