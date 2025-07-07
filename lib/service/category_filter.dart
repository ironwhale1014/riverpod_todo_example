import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_filter.g.dart';

@riverpod
Stream<List<TodoWithCategory>> getTodoWithCategory(Ref ref) {
  final category = null;
  return ref.read(todoServiceProvider.notifier).getTodoWithCategory(category);
}
