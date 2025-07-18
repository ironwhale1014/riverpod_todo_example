import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/components/custom_dialog.dart';
import 'package:drift_todo_train/common/util/date_format.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditDialog extends ConsumerStatefulWidget {
  const EditDialog(this.todoEntry, {super.key});

  final TodoEntry todoEntry;

  @override
  ConsumerState createState() => _EditDialogState();
}

class _EditDialogState extends ConsumerState<EditDialog> {
  final TextEditingController controller = TextEditingController();
  late final TodoEntry todoEntry;
  DateTime? dueDate;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoEntry = widget.todoEntry;
    if (todoEntry.description.isNotEmpty) {
      controller.text = todoEntry.description;
    }
    if (todoEntry.dueDate != null) {
      dueDate = todoEntry.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      titleText: "Edit it",
      btnLeftText: "Cancel",
      btnRightText: "OK",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(controller: controller),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (dueDate != null) ? dateTransfer(dueDate!) : 'not set dueDate',
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
                    firstDate: firstDate,
                    initialDate: initialDate,
                    lastDate: DateTime(3000),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      dueDate = selectedDate;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
        ],
      ),
      btnLeftFunc: () {
        context.pop();
      },
      btnRightFunc: () async {
        await ref
            .read(todoServiceProvider.notifier)
            .update(
              todoEntry.copyWith(
                description: controller.text.trim(),
                dueDate: Value(dueDate),
              ),
            );
        if (context.mounted) {
          context.pop();
        }
      },
    );
  }
}

// class EditDialog extends ConsumerWidget {
//   EditDialog(this.todoEntry, {super.key});
//
//   final TodoEntry todoEntry;
//   final TextEditingController controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (todoEntry.description.isNotEmpty) {
//       controller.text = todoEntry.description;
//     }
//
//     return CustomDialog(
//       titleText: "Edit it",
//       btnLeftText: "Cancel",
//       btnRightText: "OK",
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextFormField(controller: controller),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 (todoEntry.dueDate != null)
//                     ? dateTransfer(todoEntry.dueDate!)
//                     : 'not set dueDate',
//               ),
//
//               IconButton(
//                 onPressed: () async{
//                   final now = DateTime.now();
//                   final firstDate =  ;
//                   final initialDate =
//
//               final selectedDate =   await showDatePicker(
//                     context: context,
//                     firstDate: firstDate,
//                     initialDate: initialDate,
//                     lastDate: DateTime(300),
//                   );
//
//                   if(selectedDate!=null){
//
//                   }
//                 },
//                 icon: Icon(Icons.calendar_today),
//               ),
//             ],
//           ),
//         ],
//       ),
//       btnLeftFunc: () {
//         context.pop();
//       },
//       btnRightFunc: () async {
//         await ref
//             .read(todoServiceProvider.notifier)
//             .update(todoEntry.copyWith(description: controller.text.trim()));
//         if (context.mounted) {
//           context.pop();
//         }
//       },
//     );
//   }
// }
