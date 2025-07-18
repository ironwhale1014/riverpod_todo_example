import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/domain/todo_filter.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/repository/todo_repository.dart';
import 'package:drift_todo_train/service/category_state_provider.dart';
import 'package:drift_todo_train/service/todo_filter_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  @override
  BaseModel<TodoWithCategory> build() {
    paginate();
    return Loading();
  }

  Future<void> paginate() async {
    final categoryId = ref.watch(categoryStateProviderProvider)?.id;
    final filter = ref.watch(todoFilterStateProviderProvider);
    final List<TodoWithCategory>? todoWithCategories;
    switch (filter) {
      case TodoFilter.all:
        todoWithCategories = await ref
            .read(todoRepositoryProvider.notifier)
            .getTodoWithCategory(
              categoryId: categoryId,
              filter: TodoFilter.all,
            );
      case TodoFilter.isComplete:
        todoWithCategories = await ref
            .read(todoRepositoryProvider.notifier)
            .getTodoWithCategory(
              categoryId: categoryId,
              filter: TodoFilter.isComplete,
            );
      case TodoFilter.unComplete:
        todoWithCategories = await ref
            .read(todoRepositoryProvider.notifier)
            .getTodoWithCategory(
              categoryId: categoryId,
              filter: TodoFilter.unComplete,
            );
    }

    state = Model(todoWithCategories);
  }

  Future<void> delete(TodoEntry todo) async {
    await ref.read(todoRepositoryProvider.notifier).delete(todo);
    if (state is Model) {
      final datas = (state as Model<TodoWithCategory>).datas;
      final newData = datas.where((e) => e.todoEntry.id != todo.id).toList();
      state = Model(newData);
    }
  }

  Future<void> update(TodoEntry todo) async {
    await ref.read(todoRepositoryProvider.notifier).update(todo);
    if (state is Model) {
      final datas = (state as Model<TodoWithCategory>).datas;
      final newData = datas
          .map(
            (e) => e.todoEntry.id == todo.id
                ? TodoWithCategory(todoEntry: todo, category: e.category)
                : e,
          )
          .toList();
      state = Model(newData);
    }
  }

  Future<void> toggle(TodoEntry todo) async {
    await ref
        .read(todoRepositoryProvider.notifier)
        .update(todo.copyWith(isComplete: !todo.isComplete));

    if (state is Model) {
      final pState = state as Model<TodoWithCategory>;
      final newData = pState.datas
          .map(
            (e) => e.todoEntry.id == todo.id
                ? TodoWithCategory(
                    todoEntry: todo.copyWith(isComplete: !todo.isComplete),
                    category: e.category,
                  )
                : e,
          )
          .toList();

      state = Model(newData);
    }
  }

  Future<void> save({
    required String description,
    int? category,
    bool isComplete = false,
    DateTime? dueDate,
  }) async {
    final savedTodo = await ref
        .read(todoRepositoryProvider.notifier)
        .save(
          TodoEntriesCompanion.insert(
            description: description,
            category: Value(category),
            isComplete: Value(isComplete),
            dueDate: Value(dueDate),
          ),
        );

    if (state is Model) {
      final datas = (state as Model<TodoWithCategory>).datas;
      state = Model([
        ...datas,
        TodoWithCategory(
          todoEntry: savedTodo,
          category: (category == null)
              ? null
              : ref.watch(categoryStateProviderProvider),
        ),
      ]);
    }
  }
}
