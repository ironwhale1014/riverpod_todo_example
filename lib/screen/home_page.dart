import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:drift_todo_train/service/todo_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todoController = TextEditingController();

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  void _addTodos() {
    if (todoController.text.isNotEmpty) {
      final category = ref.read(categoryStateProvider);

      ref
          .read(todoServiceProvider.notifier)
          .saveTodo(description: todoController.text, categoryId: category?.id);

      todoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoWithCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: todoController,
                  onFieldSubmitted: (value) => _addTodos(),
                ),
              ),
              IconButton(onPressed: _addTodos, icon: Icon(Icons.save)),
            ],
          ),
          Expanded(
            child: todos.when(
              data: (todos) => ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ProviderScope(
                    overrides: [currentTodo.overrideWithValue(todos[index])],
                    child: TodoCard(),
                  );
                },
              ),
              error: (_, _) => Text("error"),
              loading: () => Align(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final currentTodo = Provider<TodoWithCategory>(
  (ref) => throw UnimplementedError(),
  dependencies: [],
);
