import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/database.dart';
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
    final todos = ref.watch(databaseStateProvider).todosInCategory(null);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          TextFormField(
            controller: todoController,
            onFieldSubmitted: (value) {
              logger.d(value);

              ref
                  .read(databaseStateProvider)
                  .todos
                  .insertOne(
                    TodosCompanion.insert(description: todoController.text),
                  );

              todoController.clear();
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: todos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final datas = snapshot.data!;

                  return ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(datas[index].todo.description),
                        leading: Text(datas[index].category?.name ?? '기본'),
                      );
                    },
                  );
                }
                return Center(child: const CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
