import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/screen/backup/backup.dart';
import 'package:drift_todo_train/screen/home/card.dart';
import 'package:drift_todo_train/screen/home/drawer.dart';
import 'package:drift_todo_train/screen/home/state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      final database = ref.read(appDatabaseStateProvider);
      final currentCategory = ref.read(activeCategory);

      // database
      //     .into(database.todoEntries)
      //     .insert(
      //       TodoEntriesCompanion.insert(
      //         description: _controller.text,
      //         category: Value(currentCategory?.id),
      //       ),
      //     );
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
    final currentEntries = ref.watch(entriesInCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Drift Todo list"),
        actions: [
          const BackUpIcon(),
          IconButton(
            onPressed: () => context.go('/search'),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: const CategoriesDrawer(),
      body: currentEntries.when(
        data: (entries) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return TodoCard(entries[index].todoEntry);
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          debugPrintStack(stackTrace: stackTrace, label: error.toString());
          return const Text('An error has occured');
        },
        loading: () => const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
      bottomSheet: Material(
        elevation: 12,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What needs to be done?'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _addTodoEntry(),
                      ),
                    ),
                    IconButton(
                      onPressed: _addTodoEntry,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
