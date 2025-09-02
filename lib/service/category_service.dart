import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/repository/category_repository.dart';
import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_service.g.dart';

@riverpod
class CategoryService extends _$CategoryService {
  @override
  BaseStateModel<Category> build() {
    paginate();
    return Loading();
  }

  Future<void> paginate() async {
    final List<Category> category = await ref
        .read(categoryRepositoryProvider)
        .getCategoriesWithCount();

    state = LoadedModel(category);
  }

  Future<void> saveCategory(String name) async {
    await ref.read(categoryRepositoryProvider).createCategory(name: name);
    ref.invalidateSelf();
  }
}
