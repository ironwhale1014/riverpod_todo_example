import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/screen/home/todo_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final DateFormat _format = DateFormat.yMMMd();

class TodoCard extends ConsumerWidget {
  TodoCard(this.entry) : super(key: ObjectKey(entry.id));

  final TodoEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueDate = entry.dueDate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(entry.description),
                  if (dueDate != null)
                    Text(
                      _format.format(dueDate),
                      style: TextStyle(fontSize: 12),
                    ),
                  if (dueDate == null)
                    const Text(
                      'No due date set',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
            IconButton(onPressed: () {
              showDialog(context: context, builder: (BuildContext context) =>TodoEditDialog(entry: entry));
            }, icon: const Icon(Icons.edit)),
            IconButton(color: Colors.red, onPressed: () {

              ref.read(appDatabaseStateProvider).todoEntries.deleteOne(entry);
            }, icon: const Icon(Icons.delete) ),
          ],
        ),
      ),
    );
  }
}
