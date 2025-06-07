import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  late final AppDatabase appDatabase;

  @override
  void build() {
    appDatabase = ref.watch(databaseStateProvider);
    return;
  }

  Future<void> saveTodo({required String description}) async {
    await appDatabase.todoEntries.insertOne(
      TodoEntriesCompanion.insert(description: description),
    );
  }

  void deleteTodo({required TodoEntry todo}) async {
    await appDatabase.todoEntries.deleteOne(todo);
  }

  void updateTodo({required TodoEntry todo}) async {
    await appDatabase.todoEntries.replaceOne(todo);
  }

  Stream<List<TodoEntry>> getTodoEntryStream() {
    return (appDatabase.todoEntries.select()).watch();
  }
}
