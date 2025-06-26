import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  late final AppDatabase _database;

  @override
  void build() {
    _database = ref.watch(databaseStateProvider);
    return;
  }

  void todoSave({
    required String description,
    DateTime? dueDate,
    int? categoryId,
  }) async {
    await _database.todoEntries.insertOne(
      TodoEntriesCompanion.insert(
        description: description,
        dueDate: Value(dueDate),
        category: Value(categoryId),
      ),
    );
  }

  void todoDelete(TodoEntry todoEntry) async {
    await _database.todoEntries.deleteOne(todoEntry);
  }

  void todoUpdate(TodoEntry todoEntry) async {
    await _database.todoEntries.replaceOne(todoEntry);
  }

  Stream<List<TodoEntry>> getTodoEntries() {
    return _database.todoEntries.select().watch();
  }

  Stream<List<TodoWithCategory>> getTodoWithCategory({int? categoryId}) {
    final query = _database.todoEntries.select().join([
      leftOuterJoin(
        _database.categories,
        _database.categories.id.equalsExp(_database.todoEntries.category),
      ),
    ]);

    if (categoryId != null) {
      query.where(_database.categories.id.equals(categoryId));
    } else {
      query.where(_database.categories.id.isNull());
    }

    return query
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(_database.todoEntries),
            category: row.readTableOrNull(_database.categories),
          ),
        )
        .watch();
  }
}
