import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
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

  void todoSave({required String description, DateTime? dueDate}) async {
    await _database.todoEntries.insertOne(
      TodoEntriesCompanion.insert(
        description: description,
        dueDate: Value(dueDate),
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
}
