import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_state_provider.g.dart';

enum TodoListFilter { all, uncompleted, completed }

@riverpod
class TodoListFilterState extends _$TodoListFilterState {
  @override
  TodoListFilter build() {
    return TodoListFilter.all;
  }

  void setFilter(TodoListFilter filter) {
    state = filter;
  }
}
