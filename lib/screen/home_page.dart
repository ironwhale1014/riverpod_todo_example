import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/filter_provider.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final todoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoWithCategory = ref.watch(getTodoWithCategoryProvider);
    return DefaultLayout(
      title: '홈',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextFormField(
              controller: todoController,
              onFieldSubmitted: (_) => _addTodo(ref),
            ),
            Expanded(
              child: todoWithCategory.when(
                data: (datas) => ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProviderScope(
                      overrides: [
                        currentTodoProvider.overrideWithValue(datas[index]),
                      ],
                      child: TodoCard(),
                    );
                  },
                ),
                error: (_, _) => Text('error'),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addTodo(WidgetRef ref) async {
    if (todoController.text.isNotEmpty) {
      await ref
          .read(todoServiceProvider.notifier)
          .saveTodo(
            description: todoController.text.trim(),
            categoryId: ref.read(categoryServiceProvider)?.id,
          );
      todoController.clear();
    }
  }
}

final currentTodoProvider = Provider<TodoWithCategory>(
  (ref) => throw UnimplementedError(),
);
