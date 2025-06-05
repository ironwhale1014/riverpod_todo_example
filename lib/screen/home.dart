import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:drift_todo_train/database/state.dart';
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoWithCategoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text("home", textAlign: TextAlign.center)),
      body: Column(
        children: [
          TextFormField(
            controller: _controller,
            onFieldSubmitted: (value) {
              ref
                  .read(repositoryProvider.notifier)
                  .saveTodos(description: _controller.text);
              _controller.clear();
            },
          ),
          Expanded(
            child: todos.when(
              data: (todos) => ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    ref
                        .read(repositoryProvider.notifier)
                        .deleteTodos(todo: todos[index].todoEntry);
                  },
                  title: Text(todos[index].todoEntry.description),
                ),
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
    );
  }
}
