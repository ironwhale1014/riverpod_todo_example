import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  @override
  AppDatabase? build() {
    return null;
  }

  Future<void> saveTodo({
    required String description,
    int? categoryId,
    DateTime? dueDate,
  }) async {
    await ref
        .read(databaseProvider)
        .todoEntries
        .insertOne(
          TodoEntriesCompanion.insert(
            description: description,
            dueDate: Value(dueDate),
          ),
        );
  }

  Future<void> deleteTodo(TodoEntry todo) async {
    await ref.read(databaseProvider).todoEntries.deleteOne(todo);
  }

  Future<void> updateTodo(TodoEntry todo) async {
    await ref.read(databaseProvider).todoEntries.replaceOne(todo);
  }

  Stream<List<TodoWithCategory>> getTodoWithCategory(int? category) {
    final database = ref.read(databaseProvider);
    return (database.todoEntries.select().join([
          leftOuterJoin(
            database.categories,
            database.categories.id.equalsExp(database.todoEntries.category),
          ),
        ]))
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(database.todoEntries),
            category: row.readTableOrNull(database.categories),
          ),
        )
        .watch();
  }
}
