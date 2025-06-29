import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  @override
  AppDatabase build() {
    return ref.watch(databaseProvider);
  }

  void saveTodo({required String description, DateTime? dueDate}) async {
    await state.todoEntries.insertOne(
      TodoEntriesCompanion.insert(
        description: description,
        dueDate: Value(dueDate),
      ),
    );
  }

  void updateTodo({required TodoEntry todo}) async {
    await state.todoEntries.replaceOne(todo);
  }

  void deleteTodo({required TodoEntry todo}) async {
    await state.todoEntries.deleteOne(todo);
  }

  Stream<List<TodoWithCategory>> getTodos(int? categoryId) {
    final query = state.todoEntries.select().join([
      leftOuterJoin(
        state.categories,
        state.categories.id.equalsExp(state.todoEntries.category),
      ),
    ]);

    if (categoryId != null) {
      query.where(state.todoEntries.category.equals(categoryId));
    } else {
      query.where(state.todoEntries.category.isNull());
    }

    return (query.map(
      (todo) => TodoWithCategory(
        todoEntry: todo.readTable(state.todoEntries),
        category: todo.readTableOrNull(state.categories),
      ),
    )).watch();
  }
}
