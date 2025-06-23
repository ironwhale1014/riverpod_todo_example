import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  late final AppDataBase _database;

  @override
  void build() {
    _database = ref.watch(databaseStateProvider);
    return;
  }

  saveTodo(String description) async {
    await _database.todoEntries.insertOne(
      TodoEntriesCompanion.insert(description: description),
    );
  }
}
