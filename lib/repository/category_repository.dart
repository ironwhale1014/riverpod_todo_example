import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_repository.g.dart';

@riverpod
CategoryDao categoryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao;
}

@DriftAccessor(
  tables: [CategoryEntries, TodoEntries],
) // Only needs CategoryEntries
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<CategoryEntry>> watchCategories() {
    return select(categoryEntries).watch();
  }

  Future<List<CategoryEntry>> getCategories() {
    return select(categoryEntries).get();
  }

  Future<List<Category>> getCategoriesWithCount() async {
    return db.getCategoryWithCount().map((row) {
      return Category(
        id: row.id,
        color: row.color,
        count: row.amount,
        name: row.name,
      );
    }).get();
  }

  Future<Category> getCategoryById(int? id) async {
    final categoriesWithCount = await getCategoriesWithCount();
    return categoriesWithCount.where((element) => element.id == id).first;
  }
}
