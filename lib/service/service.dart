import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/todo_with_category.dart' show TodoWithCategory;

part 'service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  late final AppDatabase appDatabase;

  @override
  void build() {
    appDatabase = ref.watch(databaseStateProvider);
    return;
  }

  Future<void> saveTodo({required String description}) async {
    await appDatabase.todos.insertOne(
      TodosCompanion.insert(description: description),
    );
  }

  void deleteTodo({required TodoEntry todo}) async {
    await appDatabase.todos.deleteOne(todo);
  }

  void updateTodo({required TodoEntry todo}) async {
    await appDatabase.todos.replaceOne(todo);
  }

  Stream<List<TodoEntry>> getTodoEntryStream() {
    return (appDatabase.todos.select()).watch();
  }

  Stream<List<TodoWithCategory>> getTodoWithCategory(int? category) {
    final query = appDatabase.todos.select().join([
      leftOuterJoin(
        appDatabase.categories,
        appDatabase.categories.id.equalsExp(appDatabase.todos.category),
      ),
    ]);

    if (category != null) {
      query.where(appDatabase.categories.id.equals(category));
    } else {
      query.where(appDatabase.categories.id.isNull());
    }

    return query
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(appDatabase.todos),
            category: row.readTableOrNull(appDatabase.categories),
          ),
        )
        .watch();
  }
}
