import 'package:drift/drift.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: TextFormField(
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
    );
  }
}
