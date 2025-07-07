import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_filter.g.dart';

enum TodoListFilter { all, active, completed }

@riverpod
class TodoListFilterNotifier extends _$TodoListFilterNotifier {
  @override
  TodoListFilter build() {
    // 여기서 초기 상태를 정의합니다.
    // StateProvider((_) => TodoListFilter.all)와 동일합니다.
    return TodoListFilter.all;
  }

  // 상태를 변경하는 메서드를 추가합니다.
  void setFilter(TodoListFilter filter) {
    state = filter;
  }
}

@riverpod
Stream<List<TodoWithCategory>> getTodoWithCategory(Ref ref) {
  final TodoListFilter filter = ref.watch(todoListFilterNotifierProvider);
  final category = null;

  switch (filter) {
    case TodoListFilter.all:
      return ref
          .read(todoServiceProvider.notifier)
          .getTodoWithCategory(category);
    case TodoListFilter.active:
      return ref
          .read(todoServiceProvider.notifier)
          .getTodoWithCategory(category, filter: TodoListFilter.active);
    case TodoListFilter.completed:
      return ref
          .read(todoServiceProvider.notifier)
          .getTodoWithCategory(category, filter: TodoListFilter.completed);
  }
}
