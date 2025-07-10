import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/service/todo_list_filter_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  @override
  BaseModel build() {
    return Loading();
  }

  Future<TodoEntry> saveTodo({
    required String description,
    int? categoryId,
    DateTime? dueDate,
  }) async {
    final id = await ref
        .read(databaseProvider)
        .todoEntries
        .insertOne(
          TodoEntriesCompanion.insert(
            description: description,
            dueDate: Value(dueDate),
            category: Value(categoryId),
          ),
        );

    final data =
        await (ref.read(databaseProvider).todoEntries.select()
              ..where((t) => t.id.equals(id)))
            .getSingle();
    return data;
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

  Future<List<TodoWithCategory>> search(String searchText) async {
    final database = ref.read(databaseProvider);
    return (database
            .search('$searchText*')
            .map(
              (row) => TodoWithCategory(todoEntry: row.todo, category: row.cat),
            ))
        .get();
  }

  Future<List<TodoWithCategory>> getTodoWithCategoryTwo({
    int? category,
    TodoListFilter filter = TodoListFilter.all,
  }) async {
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
        return query
            .map(
              (row) => TodoWithCategory(
                todoEntry: row.readTable(database.todoEntries),
                category: row.readTableOrNull(database.categories),
              ),
            )
            .get();
      case TodoListFilter.active:
        return (query..where(database.todoEntries.isComplete.equals(false)))
            .map(
              (row) => TodoWithCategory(
                todoEntry: row.readTable(database.todoEntries),
                category: row.readTableOrNull(database.categories),
              ),
            )
            .get();
      case TodoListFilter.completed:
        return (query..where(database.todoEntries.isComplete.equals(true)))
            .map(
              (row) => TodoWithCategory(
                todoEntry: row.readTable(database.todoEntries),
                category: row.readTableOrNull(database.categories),
              ),
            )
            .get();
    }
  }
}
