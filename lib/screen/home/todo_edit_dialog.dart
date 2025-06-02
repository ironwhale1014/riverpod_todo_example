import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/database/database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat.yMMMd();

class TodoEditDialog extends ConsumerStatefulWidget {
  const TodoEditDialog({super.key, required this.entry});

  final TodoEntry entry;

  @override
  ConsumerState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  final TextEditingController textController = TextEditingController();
  DateTime? _dueDate;

  @override
  void initState() {
    textController.text = widget.entry.description;
    _dueDate = widget.entry.dueDate;
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = 'No date set';
    if (_dueDate != null) {
      formattedDate = _dateFormat.format(_dueDate!);
    }

    return AlertDialog(
      title: const Text('Edit entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'What needs to be done?',
              helperText: 'Content of entry',
            ),
          ),
          Row(
            children: [
              Text(formattedDate),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = _dueDate ?? now;
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
                    if (selectedDate != null) _dueDate = selectedDate;
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
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            final updatedContent = textController.text;
            final entry = widget.entry.copyWith(
              description: updatedContent.isNotEmpty ? updatedContent : null,
              dueDate: Value(_dueDate),
            );

            ref.read(appDatabaseProvider).todoEntries.replaceOne(entry);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
