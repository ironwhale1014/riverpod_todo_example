import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'database.dart';

part 'repository_provider.g.dart';

@riverpod
class RepositoryProvider extends _$RepositoryProvider {
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
      TodosCompanion.insert(description: 'test'),
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
}
