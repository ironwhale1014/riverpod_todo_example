import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/edit_dialog.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard(this.todoWithCategory, {super.key});

  final TodoWithCategory todoWithCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TodoEntry todoEntry = todoWithCategory.todoEntry;

    return InkWell(
      onTap: () {
        ref.read(todoServiceProvider.notifier).toggle(todoEntry);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          color: todoEntry.isComplete ? Colors.greenAccent : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todoEntry.description,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        todoEntry.dueDate != null
                            ? dateTransfer(todoEntry.dueDate!)
                            : 'not set dueDate',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final offset = renderBox.localToGlobal(Offset.zero);
                    final point1 = offset.dx + renderBox.size.width;
                    final point2 = offset.dy + renderBox.size.height;
                    final selectedValue = await showMenu(
                      position: RelativeRect.fromLTRB(
                        point1,
                        point2,
                        point1,
                        point2,
                      ),
                      context: context,
                      items: [
                        PopupMenuItem(value: 'edit', child: Text('수정하기')),
                        PopupMenuItem(value: 'delete', child: Text('삭제하기')),
                      ],
                    );
                    if (selectedValue != null) {
                      switch (selectedValue) {
                        case 'edit':
                          showDialog(
                            context: context,
                            builder: (_) => EditDialog(todoEntry),
                          );
                        case 'delete':
                          ref
                              .read(todoServiceProvider.notifier)
                              .delete(todoEntry);
                      }
                    }
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
