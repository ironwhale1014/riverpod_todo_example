import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/date_format.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoEditDialog extends ConsumerStatefulWidget {
  const TodoEditDialog({super.key, required this.todoEntry});

  final TodoEntry todoEntry;

  @override
  ConsumerState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  final _controller = TextEditingController();
  late final TodoEntry todoEntry;
  DateTime? _dueDate;

  @override
  void initState() {
    todoEntry = widget.todoEntry;
    _controller.text = todoEntry.description;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'no date set';
    if (_dueDate != null) {
      formattedDate = dateFormat.format(_dueDate!).toString();
    }
    return AlertDialog(
      title: Text("Edit Todo", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(helperText: 'edit your todo'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Text(formattedDate)),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = _dueDate ?? now;
                  final firstDate = initialDate.isBefore(now)
                      ? initialDate
                      : now;

                  final selectedDate = await showDatePicker(
                    context: context,
                    firstDate: firstDate,
                    initialDate: initialDate,
                    lastDate: DateTime(3000),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
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
          child: Text("cancel"),
        ),
        TextButton(
          onPressed: () {
            final updateTodo = _controller.text;
            final todo = todoEntry.copyWith(
              description: updateTodo.isNotEmpty ? updateTodo : null,
              dueDate: Value(_dueDate),
            );

            ref.read(todoServiceProvider.notifier).updateTodo(todo: todo);
            context.pop();
          },
          child: Text("save"),
        ),
      ],
    );
  }
}
