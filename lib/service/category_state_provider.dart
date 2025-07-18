import 'package:drift_todo_train/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_state_provider.g.dart';

@riverpod
class CategoryStateProvider extends _$CategoryStateProvider {
  @override
  Category? build() {
    return null;
  }

  void changeCategory(Category? category){
    state = category;
  }
}
