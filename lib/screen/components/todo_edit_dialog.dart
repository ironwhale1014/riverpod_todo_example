import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoEditDialog extends ConsumerStatefulWidget {
  const TodoEditDialog({required this.todoEntry, super.key});

  final TodoEntry todoEntry;

  @override
  ConsumerState<TodoEditDialog> createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  final TextEditingController controller = TextEditingController();
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    controller.text = widget.todoEntry.description;
    dueDate = widget.todoEntry.dueDate;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("수정 하기"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: controller),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dueDate != null
                    ? dateFormat.format(dueDate!)
                    : 'not set due date',
                style: TextStyle(fontSize: 16),
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
                    lastDate: DateTime(3000),
                    firstDate: firstDate,
                  );

                  if (selectedDate != null) {
                    setState(() {
                      dueDate = selectedDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
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
          child: Text('cancel', style: TextStyle(fontSize: 18)),
        ),
        TextButton(
          onPressed: () async {
            context.pop();
            await ref
                .read(todoServiceProvider.notifier)
                .updateTodo(
                  todo: widget.todoEntry.copyWith(
                    dueDate: Value(dueDate),
                    description: controller.text.trim(),
                  ),
                );
          },
          child: Text('save', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
