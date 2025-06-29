import 'package:drift_todo_train/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_service.g.dart';

@riverpod
class CategoryService extends _$CategoryService {
  @override
  Category? build() {
    return null;
  }

  void changeCategory(Category category) {
    state = category;
  }


}
