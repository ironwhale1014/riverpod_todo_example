import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/screen/components/custom_dialog.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:drift_todo_train/service/todo_with_category_state_provider.dart';
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
  final controller = TextEditingController();
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    controller.text = widget.todoEntry.description;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog.withBtn(
      title: 'Edit it??',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTextFormField(controller: controller),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (dueDate != null) Text(dateFormat.format(dueDate!)),
              if (dueDate == null) Text('not set due date'),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = widget.todoEntry.dueDate ?? now;
                  final firstDate = initialDate.isBefore(now)
                      ? initialDate
                      : now;

                  final selectedDate = await showDatePicker(
                    initialDate: initialDate,
                    lastDate: DateTime(3000),
                    firstDate: firstDate,
                    context: context,
                  );

                  if (selectedDate != null) {
                    setState(() {
                      dueDate = selectedDate;
                    });
                  }
                },
                icon: Icon(Icons.calendar_month),
              ),
            ],
          ),
        ],
      ),
      leftBtnOnPressed: () {
        context.pop();
      },
      rightBtnOnPressed: () async {
        context.pop();
        ref
            .read(todoWithCategoryStateProvider.notifier)
            .update(
              widget.todoEntry.copyWith(
                description: controller.text.trim().isNotEmpty
                    ? controller.text.trim()
                    : null,
                dueDate: Value(dueDate),
              ),
            );
      },
    );
  }
}
