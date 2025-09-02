import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:drift_todo_train/repository/todo_repository.dart';
import 'package:drift_todo_train/service/category_state_provider.dart';
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
    final todosWithCategory = await ref
        .read(todoRepositoryProvider)
        .getTodosWithCategoryEntries(category);
    state = LoadedModel(todosWithCategory);
  }

  Future<void> save(String description) async {
    final category = ref.watch(categoryStateProvider);
    ref.read(todoRepositoryProvider).createTodoEntry(description, category);
    ref.invalidateSelf();
  }

  Future<void> update(TodoModel todoModel) async {
    ref.read(todoRepositoryProvider).updateTodoEntry(todoModel);
    ref.invalidateSelf();
  }

  Future<void> delete(TodoModel todo) async {
    ref.read(todoRepositoryProvider).deleteTodoEntry(todo);
    ref.invalidateSelf();
  }
}
