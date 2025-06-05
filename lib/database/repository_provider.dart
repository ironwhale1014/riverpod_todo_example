import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'database.dart';

part 'repository_provider.g.dart';

@riverpod
class Repository extends _$Repository {
  late final AppDatabase database;

  @override
  void build() {
    database = ref.read(databaseStateProvider);
    return;
  }

  Future<int> saveTodos({
    required String description,
    String? categoryId,
  }) async {
    return await database.todos.insertOne(
      TodosCompanion.insert(description: description),
    );
  }

  Future<void> updateTodos({required TodoEntry todo}) async {
    return await database.todos.replaceOne(todo);
  }

  Future<void> deleteTodos({required TodoEntry todo}) async {
    await database.todos.deleteOne(todo);
  }

  Future<TodoEntry?> findById({required int todoId}) async {
    return await (database.todos.select()
          ..where((tbl) => tbl.id.equals(todoId)))
        .getSingleOrNull();
  }

  Stream<List<TodoWithCategory>> todosInCategory(int? categoryId) {
    final query = database.todos.select().join([
      leftOuterJoin(
        database.categories,
        database.categories.id.equalsExp(database.todos.category),
      ),
    ]);

    if (categoryId != null) {
      query.where(database.categories.id.equals(categoryId));
    } else {
      query.where(database.categories.id.isNull());
    }

    return query
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(database.todos),
            category: row.readTableOrNull(database.categories),
          ),
        )
        .watch();
  }
}

class TodoWithCategory {
  final TodoEntry todoEntry;
  final Category? category;

  TodoWithCategory({required this.todoEntry, this.category});
}
