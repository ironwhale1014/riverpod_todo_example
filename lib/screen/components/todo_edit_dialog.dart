import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/util/date_util.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoEditDialog extends ConsumerStatefulWidget {
  const TodoEditDialog(this.todo, {super.key});

  final TodoEntry todo;

  @override
  ConsumerState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  late TodoEntry todo;
  final TextEditingController controller = TextEditingController();
  DateTime? dueDate;

  @override
  void initState() {
    todo = widget.todo;
    controller.text = widget.todo.description;
    dueDate = widget.todo.dueDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("EDIT TODO"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(controller: controller),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dueDate != null
                    ? dateFormat.format(dueDate!)
                    : "not set due date",
              ),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = dueDate ?? now;
                  final firstDate = initialDate.isBefore(now)
                      ? initialDate
                      : now;

                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: DateTime(3000),
                  );

                  setState(() {
                    dueDate = selectedDate;
                  });
                },
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
        ],
      ),
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
                .todoUpdate(
                  todo.copyWith(
                    description: controller.text,
                    dueDate: Value(dueDate),
                  ),
                );
            context.pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
