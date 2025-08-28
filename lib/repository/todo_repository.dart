import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository.g.dart';

class TodoWithCategoryFromEntry {
  final TodoEntry todo;
  final CategoryEntry? category;

  TodoWithCategoryFromEntry({required this.todo, this.category});
}

@riverpod
TodoDao todoRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.todoDao; // Use the generated accessor
}

@DriftAccessor(tables: [CategoryEntries, TodoEntries])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(super.db);

  // Method to watch todos with their categories
  Future<List<TodoModel>> getTodosWithCategoryEntries() async {
    final query = select(todoEntries).join([
      leftOuterJoin(
        categoryEntries,
        categoryEntries.id.equalsExp(todoEntries.category),
      ),
    ]);

    final List<TodoWithCategoryFromEntry> todos = (await query.get())
        .map(_mapper)
        .toList();

    return todos.map(_todoModelMapper).toList();
  }

  Future<TodoModel> getTodoById(int id) async {
    final todoEntry = await (select(
      todoEntries,
    )..where((row) => row.id.equals(id))).getSingle();

    Category? category = await db.categoryDao.getCategoryById(
      todoEntry.category,
    );

    return TodoModel(
      id: todoEntry.id,
      description: todoEntry.description,
      category: category,
    );
  }

  Future<TodoModel> createTodoEntry(TodoModel todoModel) async {
    final todo = TodoEntriesCompanion.insert(
      description: todoModel.description,
      category: Value(todoModel.category?.id),
    );

    final id = await todoEntries.insertOne(todo);
    return getTodoById(id);
  }

  Future<TodoModel> updateTodoEntry(TodoModel todoModel) async {
    final todoEntry = await _findByIdTodoEntry(todoModel.id);

    await todoEntries.replaceOne(
      todoEntry.copyWith(
        description: todoModel.description,
        category: Value(todoModel.category?.id),
      ),
    );
    return getTodoById(todoModel.id);
  }

  Future<void> deleteTodoEntry(TodoEntry todo) async {
    await todoEntries.deleteOne(todo);
  }

  Future<TodoEntry> _findByIdTodoEntry(int id) async {
    return (select(todoEntries)..where((row) => row.id.equals(id))).getSingle();
  }

  TodoModel _todoModelMapper(row) => TodoModel(
    id: row.todo.id,
    description: row.todo.description,
    category: (row.category != null)
        ? Category(
            id: row.category!.id,
            name: row.category!.name,
            color: row.category!.color,
            count: row.category.count,
          )
        : null,
  );

  TodoWithCategoryFromEntry _mapper(row) => TodoWithCategoryFromEntry(
    todo: row.readTable(todoEntries),
    category: row.readTableOrNull(categoryEntries),
  );
}
