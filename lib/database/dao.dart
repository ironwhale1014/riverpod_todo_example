import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dao.g.dart';

// Simple data class to hold results from the join
class TodoWithCategoryFromEntry {
  final TodoEntry todo;
  final CategoryEntry? category;

  TodoWithCategoryFromEntry({required this.todo, this.category});
}

@riverpod
TodoDao todoDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.todoDao; // Use the generated accessor
}

@riverpod
CategoryDao categoryDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao; // Use the generated accessor
}

@DriftAccessor(tables: [CategoryEntries, TodoEntries])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(super.db);

  // Method to watch todos with their categories
  Stream<List<TodoWithCategoryFromEntry>> watchTodosWithCategory() {
    final query = select(todoEntries).join([
      leftOuterJoin(
        categoryEntries,
        categoryEntries.id.equalsExp(todoEntries.category),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TodoWithCategoryFromEntry(
          todo: row.readTable(todoEntries),
          category: row.readTableOrNull(categoryEntries),
        );
      }).toList();
    });
  }

  Future<TodoEntry> getTodoEntryById(int id) async {
    return await (select(
      todoEntries,
    )..where((row) => row.id.equals(id))).getSingle();
  }

  Future<TodoEntry> createTodoEntry(TodoEntriesCompanion todo) async {
    final id = await into(todoEntries).insert(todo);
    return getTodoEntryById(id);
  }

  Future<TodoEntry> updateTodoEntry(TodoEntry todo) async {
    await update(todoEntries).replace(todo);
    return getTodoEntryById(todo.id);
  }

  Future<void> deleteTodoEntry(TodoEntry todo) async {
    await delete(todoEntries).delete(todo);
  }
}

@DriftAccessor(tables: [CategoryEntries]) // Only needs CategoryEntries
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<CategoryEntry>> watchCategories() {
    return select(categoryEntries).watch();
  }

  Future<List<CategoryEntry>> getCategories() {
    return select(categoryEntries).get();
  }
}
