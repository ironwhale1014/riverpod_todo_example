import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:drift_todo_train/repository/todo_repository.dart';
import 'package:drift_todo_train/service/category_state_provider.dart';
import 'package:drift_todo_train/service/filter_state_provider.dart';
import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

@riverpod
class TodoService extends _$TodoService {
  @override
  BaseStateModel<TodoModel> build() {
    paginate();
    return Loading();
  }

  Future<void> paginate() async {
    final category = ref.watch(categoryStateProvider);
    final filter = ref.watch(todoListFilterStateProvider);

    final todosWithCategory = await ref
        .read(todoRepositoryProvider)
        .getTodosWithCategoryEntries(category, filter: filter);
    state = LoadedModel(todosWithCategory);
  }

  Future<void> toggle(bool isDone, TodoModel todoModel) async {
    await ref
        .read(todoRepositoryProvider)
        .updateTodoEntry(todoModel.copyWith(isDone: isDone));
  }

  Future<void> save(String description, DateTime? dueDate) async {
    final category = ref.read(categoryStateProvider);
    ref
        .read(todoRepositoryProvider)
        .createTodoEntry(description, category, dueDate);
    ref.invalidateSelf();
  }

  Future<void> update(TodoModel todoModel) async {
    await ref.read(todoRepositoryProvider).updateTodoEntry(todoModel);
    ref.invalidateSelf();
  }

  Future<void> delete(TodoModel todo) async {
    ref.read(todoRepositoryProvider).deleteTodoEntry(todo);
    ref.invalidateSelf();
  }
}
