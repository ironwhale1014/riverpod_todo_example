import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
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
}
