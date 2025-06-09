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

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoWithCategoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: Column(
        children: [
          TextFormField(
            controller: _controller,
            onFieldSubmitted: (_) async {
              await ref
                  .read(todoServiceProvider.notifier)
                  .saveTodo(description: _controller.text);
              _controller.clear();
            },
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
