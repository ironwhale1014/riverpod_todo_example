import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  @override
  AppDatabase build() {
    return ref.watch(appDatabaseProvider);
  }

  void todoSave({
    required String description,
    DateTime? dueDate,
    int? categoryId,
  }) async {
    await state.todoEntries.insertOne(
      TodoEntriesCompanion.insert(
        description: description,
        dueDate: Value(dueDate),
        category: Value(categoryId),
      ),
    );
  }

  void todoDelete(TodoEntry todoEntry) async {
    await state.todoEntries.deleteOne(todoEntry);
  }

  void todoUpdate(TodoEntry todoEntry) async {
    await state.todoEntries.replaceOne(todoEntry);
  }

  Stream<List<TodoEntry>> getTodoEntries() {
    return state.todoEntries.select().watch();
  }

  Stream<List<TodoWithCategory>> getTodoWithCategory({int? categoryId}) {
    final query = state.todoEntries.select().join([
      leftOuterJoin(
        state.categories,
        state.categories.id.equalsExp(state.todoEntries.category),
      ),
    ]);

    if (categoryId != null) {
      query.where(state.categories.id.equals(categoryId));
    } else {
      query.where(state.categories.id.isNull());
    }

    return query
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(state.todoEntries),
            category: row.readTableOrNull(state.categories),
          ),
        )
        .watch();
  }

  Future<List<TodoWithCategory>> searchTodos(String query) async {
    final results = await state.searchTodos(query).get();
    return results
        .map((row) => TodoWithCategory(todoEntry: row.t, category: row.c))
        .toList();
  }
}
