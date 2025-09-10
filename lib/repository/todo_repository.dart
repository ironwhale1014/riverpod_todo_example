import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:drift_todo_train/service/filter_state_provider.dart';
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
  Future<List<TodoModel>> getTodosWithCategoryEntries(
    Category? category, {
    TodoListFilter filter = TodoListFilter.all,
  }) async {
    final query = select(todoEntries).join([
      leftOuterJoin(
        categoryEntries,
        categoryEntries.id.equalsExp(todoEntries.category),
      ),
    ]);

    if (category != null && category.id != null) {
      query.where(todoEntries.category.equals(category.id!));
    } else {
      query.where(todoEntries.category.isNull());
    }

    final List<TodoWithCategoryFromEntry> todos = [];

    switch (filter) {
      case TodoListFilter.all:
        break;
      case TodoListFilter.uncompleted:
        query.where(todoEntries.isDone.equals(false));
      case TodoListFilter.completed:
        query.where(todoEntries.isDone.equals(true));
    }

    todos.addAll((await query.get()).map(_mapper).toList());
    final count = todos.length;

    return todos.map((row) => _todoModelMapper(row, count)).toList();
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
      isDone: todoEntry.isDone,
      category: category,
    );
  }

  Future<TodoModel> createTodoEntry(
    String description,
    Category? category,
    DateTime? dueDate,
  ) async {
    final todo = TodoEntriesCompanion.insert(
      description: description,
      category: Value(category?.id),
      dueData: Value(dueDate),
      isDone: Value(false),
    );

    final id = await todoEntries.insertOne(todo);
    return getTodoById(id);
  }

  Future<void> updateTodoEntry(TodoModel todoModel) async {
    await (update(
      todoEntries,
    )..where(((e) => e.id.equals(todoModel.id)))).write(
      TodoEntriesCompanion.insert(
        description: todoModel.description,
        dueData: Value(todoModel.dueDate),
        category: Value(todoModel.category?.id),
        isDone: Value(todoModel.isDone),
      ),
    );
  }

  Future<void> deleteTodoEntry(TodoModel todo) async {
    await (delete(todoEntries)..where((row) => row.id.equals(todo.id))).go();
  }

  TodoModel _todoModelMapper(TodoWithCategoryFromEntry row, int count) =>
      TodoModel(
        id: row.todo.id,
        description: row.todo.description,
        dueDate: row.todo.dueData,
        isDone: row.todo.isDone,
        category: (row.category != null)
            ? Category(
                id: row.category!.id,
                name: row.category!.name,
                color: row.category!.color,
                count: count,
              )
            : null,
      );

  TodoWithCategoryFromEntry _mapper(row) => TodoWithCategoryFromEntry(
    todo: row.readTable(todoEntries),
    category: row.readTableOrNull(categoryEntries),
  );
}
