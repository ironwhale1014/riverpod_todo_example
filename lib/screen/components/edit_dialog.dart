import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/date_format.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditDialog extends ConsumerStatefulWidget {
  const EditDialog({super.key, required this.todoEntry});

  final TodoEntry todoEntry;

  @override
  ConsumerState createState() => _EditDialogState();
}

class _EditDialogState extends ConsumerState<EditDialog> {
  late final TodoEntry todoEntry;
  final TextEditingController controller = TextEditingController();
  DateTime? dueDate;

  @override
  void initState() {
    todoEntry = widget.todoEntry;
    controller.text = todoEntry.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'not set due date';
    if (dueDate != null) {
      formattedDate = dateFormat.format(dueDate!);
    }
    return AlertDialog(
      title: Text('edit todo', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller,
            autofocus: true,
            onFieldSubmitted: (_) => _updateTodo(),
            decoration: InputDecoration(helperText: 'edit your todo'),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text(formattedDate)),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = dueDate ?? now;
                  final firstDate = initialDate.isBefore(now)
                      ? initialDate
                      : now;
                  final lastDate = DateTime(3000);

                  final selectedDate = await showDatePicker(
                    context: context,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    initialDate: initialDate,
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
          child: Text('cancel'),
        ),
        TextButton(onPressed: _updateTodo, child: Text('save')),
      ],
    );
  }

  _updateTodo() {
    final todo = todoEntry.copyWith(
      description: controller.text,
      dueDate: Value(dueDate),
    );
    ref.read(repositoryProvider.notifier).updateTodos(todo: todo);
    context.pop();
  }
}
