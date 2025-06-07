import 'package:drift_todo_train/service/service.dart';
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
    final todos = ref.watch(todoServiceProvider.notifier).getTodoEntryStream();
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
            child: StreamBuilder(
              stream: todos,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  final todos = snapshot.data!;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(todos[index].description),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            ref
                                .read(todoServiceProvider.notifier)
                                .deleteTodo(todo: todos[index]);
                          },
                        ),
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
