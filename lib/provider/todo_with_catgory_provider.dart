import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/util/logger.dart';

part 'todo_with_catgory_provider.g.dart';

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
Stream<List<TodoWithCategory>> getTodoWithCategory(Ref ref) {
  final todoService = ref.watch(todoServiceProvider.notifier);
  final int? categoryId = ref.watch(categoryStateProvider)?.id;
  logger.d('getTodoWithCategory');
  return todoService.getTodoWithCategory(categoryId: categoryId);
}
