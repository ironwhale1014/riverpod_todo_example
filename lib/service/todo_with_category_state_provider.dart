import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/service/category_filter.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_with_category_state_provider.g.dart';

@riverpod
class TodoWithCategoryState extends _$TodoWithCategoryState {
  @override
  BaseModel build() {
    paginate();
    return Loading();
  }

  Future<void> paginate() async {
    final TodoListFilter filter = ref.watch(todoListFilterNotifierProvider);
    final int? category = ref.watch(categoryStateProvider)?.id;

    switch (filter) {
      case TodoListFilter.all:
        state = Model(
          await ref
              .read(todoServiceProvider.notifier)
              .getTodoWithCategory(category, filter: TodoListFilter.all),
        );

      case TodoListFilter.active:
        state = Model(
          await ref
              .read(todoServiceProvider.notifier)
              .getTodoWithCategory(category, filter: TodoListFilter.active),
        );
      case TodoListFilter.completed:
        state = Model(
          await ref
              .read(todoServiceProvider.notifier)
              .getTodoWithCategory(category, filter: TodoListFilter.completed),
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
      final datas = (state as Model<TodoWithCategory>).data;
      final newData = datas
          .map(
            (e) => e.todoEntry.id == todo.id
                ? TodoWithCategory(
                    category: e.category,
                    todoEntry: e.todoEntry.copyWith(
                      isComplete: !todo.isComplete,
                    ),
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
      final datas = (state as Model<TodoWithCategory>).data;
      final newData = datas.where((e) => e.todoEntry.id != todo.id).toList();
      state = Model(newData);
    }
  }

  Future<void> update(TodoEntry todo) async {
    await ref.read(todoServiceProvider.notifier).updateTodo(todo);

    if (state is Model) {
      final datas = (state as Model<TodoWithCategory>).data;
      final newData = datas
          .map(
            (e) => e.todoEntry.id == todo.id
                ? TodoWithCategory(category: e.category, todoEntry: todo)
                : e,
          )
          .toList();

      state = Model(newData);
    }
  }

  Future<void> save({
    required String description,
    int? categoryId,
    DateTime? dueTime,
  }) async {
    final todoEntry = await ref
        .read(todoServiceProvider.notifier)
        .saveTodo(
          description: description,
          categoryId: categoryId,
          dueDate: dueTime,
        );

    Category? category;
    if (categoryId != null) {
      category = ref.read(categoryStateProvider);
    }

    if (state is Model) {
      final datas = (state as Model<TodoWithCategory>).data;
      final newTodoWithCategory = TodoWithCategory(
        todoEntry: todoEntry,
        category: category,
      );

      final newData = [...datas, newTodoWithCategory];
      state = Model(newData);
    }
  }
}
