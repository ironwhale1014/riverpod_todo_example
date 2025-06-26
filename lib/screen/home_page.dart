import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: 'Home Page',
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            onFieldSubmitted: (_) {
              if (controller.text.isNotEmpty) {
                ref
                    .read(todoServiceProvider.notifier)
                    .todoSave(description: controller.text.trim());
                controller.clear();
              }
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: ref.watch(todoServiceProvider.notifier).getTodoEntries(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<TodoEntry> todoEntries = snapshot.data!;

                  return ListView.builder(
                    itemCount: todoEntries.length,
                    itemBuilder: (context, index) {
                      final todoEntry = todoEntries[index];
                      return ListTile(
                        title: Text(todoEntry.description),
                        trailing: Text(todoEntry.dueDate?.toString() ?? 'null'),
                      );
                    },
                  );
                }
                return Text("no data");
              },
            ),
          ),
        ],
      ),
    );
  }
}
