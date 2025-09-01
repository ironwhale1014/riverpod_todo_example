import 'package:drift_todo_train/domain/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_state_provider.g.dart';

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
