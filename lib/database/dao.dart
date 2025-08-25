import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/tables.dart';

part 'dao.g.dart';


@DriftAccessor(tables: [Categories, TodoEntries])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(super.db);

  Future<TodoEntry> getTodoEntryById(int id) async {
    return await (select(
      todoEntries,
    )..where((row) => row.id.equals(id))).getSingle();
  }

  Future<TodoEntry> createTodoEntry(TodoEntriesCompanion todo) async {
    final id = await todoEntries.insertOne(todo);
    return getTodoEntryById(id);
  }

  Future<TodoEntry> updateTodoEntry(TodoEntry todo) async {
    await todoEntries.replaceOne(todo);
    return getTodoEntryById(todo.id);
  }

  Future<void> deleteTodoEntry(TodoEntry todo) async {
    await todoEntries.deleteOne(todo);
  }
}

@DriftAccessor(tables: [Categories, TodoEntries])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);
}
