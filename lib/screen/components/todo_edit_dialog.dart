import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat.yMMMd();

class TodoEditDialog extends ConsumerStatefulWidget {
  const TodoEditDialog({super.key, required this.todoEntry});

  final TodoEntry todoEntry;

  @override
  ConsumerState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  late final TodoEntry todoEntry;
  final TextEditingController textEditingController = TextEditingController();
  DateTime? dueDate;

  @override
  void initState() {
    todoEntry = widget.todoEntry;
    textEditingController.text = todoEntry.description;
    dueDate = todoEntry.dueDate;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = 'No date set';
    if (dueDate != null) {
      formattedDate = _dateFormat.format(dueDate!);
    }
    return AlertDialog(
      title: const Text('Edit page', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: 'What needs to do done?',
              helperText: 'Content of todo',
            ),
          ),
          Row(
            children: [
              Text(formattedDate),
              Spacer(),
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
                    if (selectedDate != null) {
                      dueDate = selectedDate;
                    }
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
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final updatedContent = textEditingController.text;
            final updatedTodo = todoEntry.copyWith(
              description: updatedContent.isNotEmpty ? updatedContent : null,
              dueDate: Value(dueDate),
            );
            ref
                .read(todoServiceProvider.notifier)
                .updateTodo(todo: updatedTodo);
            Navigator.pop(context);
          },
          child: Text('save'),
        ),
      ],
    );
  }
}
