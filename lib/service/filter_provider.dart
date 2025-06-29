import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

@riverpod
Stream<List<TodoWithCategory>> getTodoWithCategory(Ref ref) {
  int? categoryId = ref.watch(categoryServiceProvider)?.id;
  return ref.read(todoServiceProvider.notifier).getTodos(categoryId);
}
