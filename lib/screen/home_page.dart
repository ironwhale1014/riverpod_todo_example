import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/service/filter_provider.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final todoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    addTodo() async {
      if (todoController.text.isNotEmpty) {
        ref
            .read(todoServiceProvider.notifier)
            .saveTodo(description: todoController.text.trim());
        todoController.clear();
      }
    }

    final todoWithCategory = ref.watch(getTodoWithCategoryProvider);
    return DefaultLayout(
      title: '홈',
      child: Column(
        children: [
          TextFormField(
            controller: todoController,
            onFieldSubmitted: (_) => addTodo(),
          ),
          Expanded(
            child: todoWithCategory.when(
              data: (datas) => ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(datas[index].todoEntry.description),
                  );
                },
              ),
              error: (_, _) => Text('error'),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
