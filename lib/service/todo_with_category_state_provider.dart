import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/service/todo_list_filter_state_provider.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift_todo_train/service/category_service.dart';
import '../domain/todo_with_category.dart';

part 'todo_with_category_state_provider.g.dart';

@riverpod
class TodoWithCategoryState extends _$TodoWithCategoryState {
  @override
  BaseModel<TodoWithCategory> build() {
    paginate();
    return Loading();
  }

  Future<void> paginate() async {
    final TodoListFilter filter = ref.watch(todoListFilterStateProvider);
    final category = ref.watch(categoryStateProvider)?.id;

    switch (filter) {
      case TodoListFilter.all:
        state = Model(
          await ref
              .read(todoServiceProvider.notifier)
              .getTodoWithCategoryTwo(category: category),
        );
      case TodoListFilter.active:
        state = Model(
          await ref
              .read(todoServiceProvider.notifier)
              .getTodoWithCategoryTwo(
                category: category,
                filter: TodoListFilter.active,
              ),
        );
      case TodoListFilter.completed:
        state = Model(
          await ref
              .read(todoServiceProvider.notifier)
              .getTodoWithCategoryTwo(
                category: category,
                filter: TodoListFilter.completed,
              ),
        );
    }
  }

  Future<void> search(String searchText) async {
    final datas = await ref
        .read(todoServiceProvider.notifier)
        .search(searchText);
    if (datas.isEmpty) {
      state = EmptyModel(datas);
      return;
    }
    state = Model(datas);
  }

  Future<void> toggle(TodoEntry todo) async {
    await ref.read(todoServiceProvider.notifier).toggleTodo(todo);
    if (state is Model) {
      final data = (state as Model<TodoWithCategory>).data;
      final newData = data
          .map(
            (e) => e.todoEntry.id == todo.id
                ? TodoWithCategory(
                    todoEntry: e.todoEntry.copyWith(
                      isComplete: !todo.isComplete,
                    ),
                    category: e.category,
                  )
                : e,
          )
          .toList();
      state = Model(newData);
    }
  }

  Future<void> delete(TodoEntry todo) async {
    await ref.read(todoServiceProvider.notifier).deleteTodo(todo);
    if (state is Model) {
      final data = (state as Model<TodoWithCategory>).data;
      final newData = data
          .where((element) => element.todoEntry.id != todo.id)
          .toList();
      state = Model(newData);
    }
  }

  Future<void> update(TodoEntry todo) async {
    await ref.read(todoServiceProvider.notifier).updateTodo(todo);
    if (state is Model) {
      final data = (state as Model<TodoWithCategory>).data;
      final newData = data
          .map(
            (element) => element.todoEntry.id == todo.id
                ? TodoWithCategory(todoEntry: todo)
                : element,
          )
          .toList();

      state = Model(newData);
    }
  }

  Future<void> save({
    required String description,
    int? categoryId,
    DateTime? dueDate,
  }) async {
    final todoEntry = await ref
        .read(todoServiceProvider.notifier)
        .saveTodo(
          description: description,
          categoryId: categoryId,
          dueDate: dueDate,
        );
    Category? category;
    if (categoryId != null) {
      category = await ref
          .read(categoryServiceProvider.notifier)
          .findById(categoryId);
    }
    if (state is Model) {
      final data = (state as Model<TodoWithCategory>).data;
      final newTodoWithCategory = TodoWithCategory(
        todoEntry: todoEntry,
        category: category,
      );

      final newData = [...data, newTodoWithCategory];

      state = Model(newData);
    }
  }
}
