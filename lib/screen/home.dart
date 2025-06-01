import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/screen/home/state.dart';
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
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _addTodoEntry() {
    if (_controller.text.isNotEmpty) {
      final database = ref.read(appDatabaseProvider);
      final currentCategory = ref.read(activeCategory);

      database.todoEntries.insertOne(
        TodoEntriesCompanion.insert(
          description: _controller.text,
          category: Value(currentCategory?.id),
        ),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
