import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Stream<List<TodoEntry>> todoEntries = ref
        .watch(todoServiceProvider.notifier)
        .getTodoEntry();
    return DefaultLayout(
      title: 'home',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: controller,
              onFieldSubmitted: (_) {
                if (controller.text.isNotEmpty) {
                  ref
                      .watch(todoServiceProvider.notifier)
                      .saveTodo(description: controller.text);
                  controller.clear();
                }
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: todoEntries,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].description),
                      );
                    },
                  );
                }
                return Center(child: Text('투두 없음'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
