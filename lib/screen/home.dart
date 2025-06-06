import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:drift_todo_train/database/state.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    final todos = ref.watch(todoWithCategoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text("home", textAlign: TextAlign.center)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              onFieldSubmitted: (value) {
                ref
                    .read(repositoryProvider.notifier)
                    .saveTodos(description: controller.text);
                controller.clear();
              },
            ),
            Expanded(
              child: todos.when(
                data: (todos) => ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) => ProviderScope(
                      overrides: [currentTodo.overrideWithValue(todos[index])],
                      child: const TodoCard()),
                ),
                error: (_, _) => Text("error"),
                loading: () {
                  return const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final currentTodo = Provider<TodoWithCategory>(
  (ref) => throw UnimplementedError(),
  dependencies: [],
);
