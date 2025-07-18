import 'package:drift_todo_train/domain/todo_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_filter_state_provider.g.dart';

@riverpod
class TodoFilterStateProvider extends _$TodoFilterStateProvider {
  @override
  TodoFilter build() {
    return TodoFilter.all;
  }

  void changeFilter(TodoFilter filter) {
    state = filter;
  }
}
