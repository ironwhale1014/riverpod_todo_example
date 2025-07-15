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
