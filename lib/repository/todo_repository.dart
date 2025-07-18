import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_filter.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository.g.dart';

@riverpod
class TodoRepository extends _$TodoRepository {
  @override
  void build() {
    return;
  }

  Future<TodoEntry> save(TodoEntriesCompanion todo) async {
    final id = await ref.read(databaseProvider).todoEntries.insertOne(todo);

    return await (ref.read(databaseProvider).todoEntries.select()
          ..where((e) => e.id.equals(id)))
        .getSingle();
  }

  Future<void> update(TodoEntry todo) async {
    await ref.read(databaseProvider).todoEntries.replaceOne(todo);
  }

  Future<void> delete(TodoEntry todo) async {
    await ref.read(databaseProvider).todoEntries.deleteOne(todo);
  }

  Future<List<TodoWithCategory>> getTodoWithCategory({
    int? categoryId,
    TodoFilter filter = TodoFilter.all,
  }) async {
    final todoEntries = ref.read(databaseProvider).todoEntries;
    final categories = ref.read(databaseProvider).categories;
    final query = todoEntries.select().join([
      leftOuterJoin(categories, categories.id.equalsExp(todoEntries.category)),
    ]);

    if (categoryId != null) {
      query.where(categories.id.equals(categoryId));
    } else {
      query.where(categories.id.isNull());
    }

    switch (filter) {
      case TodoFilter.all:
        return query.map(_mapRowToTodoWithCategory).get();
      case TodoFilter.isComplete:
        return (query..where(todoEntries.isComplete.equals(true)))
            .map(_mapRowToTodoWithCategory)
            .get();
      case TodoFilter.unComplete:
        return (query..where(todoEntries.isComplete.equals(false)))
            .map(_mapRowToTodoWithCategory)
            .get();
    }
  }

  TodoWithCategory _mapRowToTodoWithCategory(row) => TodoWithCategory(
    todoEntry: row.readTable(ref.read(databaseProvider).todoEntries),
    category: row.readTableOrNull(ref.read(databaseProvider).categories),
  );
}
