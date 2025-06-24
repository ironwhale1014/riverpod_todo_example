import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  late final AppDatabase _database;

  @override
  void build() {
    _database = ref.watch(databaseProvider);
    return;
  }

  Stream<List<TodoEntry>> getTodoEntry() {
    return _database.todoEntries.select().watch();
  }

  void saveTodo({required String description, DateTime? dueData}) async {
    _database.todoEntries.insertOne(
      TodoEntriesCompanion.insert(
        description: description,
        dueDate: Value(dueData),
      ),
    );
  }
}
