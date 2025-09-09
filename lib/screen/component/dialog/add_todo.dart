import 'package:drift_todo_train/common/util/date_format.dart';
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
    final descriptionController = useTextEditingController(
      text: todo?.description,
    );
    final dueDateState = useState<DateTime?>(todo?.dueDate);

    return AlertDialog(
      title: Text('Add Todo', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: descriptionController),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = dueDateState.value ?? now;
                  final firstDate = initialDate.isBefore(now)
                      ? initialDate
                      : now;
                  final pickDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: DateTime(3000),
                  );
                  if (pickDate != null) {
                    dueDateState.value = pickDate;
                  }
                },
                icon: Icon(Icons.calendar_month),
              ),
              if (dueDateState.value != null)
                Text(getDateToString(dueDateState.value!)),
              if (dueDateState.value == null) Text('pick due Date'),
            ],
          ),
        ],
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
                      dueDate: dueDateState.value,
                    ),
                  );
            } else {
              ref
                  .read(todoServiceProvider.notifier)
                  .save(descriptionController.text.trim(), dueDateState.value);
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
