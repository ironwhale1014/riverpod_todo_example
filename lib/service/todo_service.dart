import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/service/category_filter.dart';
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

  Future<void> toggleTodo(TodoEntry todo) async {
    await ref
        .read(databaseProvider)
        .todoEntries
        .replaceOne(todo.copyWith(isComplete: !todo.isComplete));
  }

  Future<void> updateTodo(TodoEntry todo) async {
    await ref.read(databaseProvider).todoEntries.replaceOne(todo);
  }

  Stream<List<TodoWithCategory>> getTodoWithCategory(
    int? category, {
    TodoListFilter filter = TodoListFilter.all,
  }) {
    final database = ref.read(databaseProvider);

    final query = database.todoEntries.select().join([
      leftOuterJoin(
        database.categories,
        database.categories.id.equalsExp(database.todoEntries.category),
      ),
    ]);

    if (category != null) {
      query.where(database.todoEntries.category.equals(category));
    } else {
      query.where(database.todoEntries.category.isNull());
    }
    switch (filter) {
      case TodoListFilter.all:
        // TODO: Handle this case.
        return query
            .map(
              (row) => TodoWithCategory(
                todoEntry: row.readTable(database.todoEntries),
                category: row.readTableOrNull(database.categories),
              ),
            )
            .watch();
      case TodoListFilter.active:
        return (query..where(database.todoEntries.isComplete.equals(false)))
            .map(
              (row) => TodoWithCategory(
                todoEntry: row.readTable(database.todoEntries),
                category: row.readTableOrNull(database.categories),
              ),
            )
            .watch();
      case TodoListFilter.completed:
        return (query..where(database.todoEntries.isComplete.equals(true)))
            .map(
              (row) => TodoWithCategory(
                todoEntry: row.readTable(database.todoEntries),
                category: row.readTableOrNull(database.categories),
              ),
            )
            .watch();
    }
  }
}
