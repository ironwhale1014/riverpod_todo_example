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

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoWithCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          TextFormField(
            controller: todoController,
            onFieldSubmitted: (value) {
              ref
                  .read(todoServiceProvider.notifier)
                  .saveTodo(description: todoController.text);
              todoController.clear();
            },
          ),
          Expanded(
            child: todos.when(
              data: (todos) => ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todos[index].todoEntry.description),
                    leading: Text(todos[index].category?.name ?? '기본'),
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
