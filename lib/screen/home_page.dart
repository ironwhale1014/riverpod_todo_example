import 'package:drift_todo_train/service/service.dart';
import 'package:drift_todo_train/service/todo_with_category_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _controller = TextEditingController();

  void _addTodos() async {
    if (_controller.text.isNotEmpty) {
      final category = ref.read(categoryStateProvider);

      await ref
          .read(todoServiceProvider.notifier)
          .saveTodo(description: _controller.text, category: category?.id);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoWithCategoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  onFieldSubmitted: (_) => _addTodos(),
                ),
              ),
              TextButton(onPressed: _addTodos, child: Text("save")),
            ],
          ),
          Expanded(
            child: todos.when(
              data: (todos) {
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todos[index].todoEntry;
                    return ListTile(title: Text(todo.description));
                  },
                );
              },
              error: (_, _) => Text("Error"),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
