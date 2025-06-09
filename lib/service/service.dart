import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    await appDatabase.todoEntries.insertOne(
      TodoEntriesCompanion.insert(description: description),
    );
  }

  void deleteTodo({required TodoEntry todo}) async {
    await appDatabase.todoEntries.deleteOne(todo);
  }

  void updateTodo({required TodoEntry todo}) async {
    await appDatabase.todoEntries.replaceOne(todo);
  }

  Stream<List<TodoEntry>> getTodoEntryStream() {
    return (appDatabase.todoEntries.select()).watch();
  }

  Stream<List<TodoWithCategory>> getTodoEntryWithCategory(int? categoryId) {
    final query = appDatabase.todoEntries.select().join([
      leftOuterJoin(
        appDatabase.categories,
        appDatabase.categories.id.equalsExp(appDatabase.todoEntries.category),
      ),
    ]);

    if (categoryId != null) {
      query.where(appDatabase.todoEntries.category.equals(categoryId));
    } else {
      query.where(appDatabase.todoEntries.category.isNull());
    }
    return query
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(appDatabase.todoEntries),
            category: row.readTableOrNull(appDatabase.categories),
          ),
        )
        .watch();
  }
}
