import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_with_category_provider.g.dart';

@riverpod
class CategoryState extends _$CategoryState {
  @override
  Category? build() {
    return null;
  }

  void setCategory(Category category) {
    state = category;
  }
}

final todoWithCategoryProvider = StreamProvider<List<TodoWithCategory>>((ref) {
  final category = ref.watch(categoryStateProvider);

  return ref
      .read(todoServiceProvider.notifier)
      .getTodoEntryWithCategory(category?.id);
});
