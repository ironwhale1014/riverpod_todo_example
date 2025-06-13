import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@riverpod
class CategoryState extends _$CategoryState {
  @override
  Category? build() {
    return null;
  }

  void setCategory(Category? category) {
    state = category;
  }
}

@riverpod
Stream<List<TodoWithCategory>> todoWithCategory(Ref ref) {
  final categoryId = ref.watch(categoryStateProvider)?.id;
  return ref.read(repositoryProvider.notifier).todosInCategory(categoryId);
}