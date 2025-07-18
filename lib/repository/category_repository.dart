import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_repository.g.dart';

@riverpod
class CategoryRepository extends _$CategoryRepository {
  @override
  void build() {
    return;
  }

  Future<Category> save(CategoriesCompanion category) async {
    final db = ref.read(databaseProvider).categories;
    final id = await db.insertOne(category);

    return await (db.select()..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<void> update(Category category) async {
    final db = ref.read(databaseProvider).categories;
    await db.replaceOne(category);
  }

  Future<void> delete(Category category) async {
    final db = ref.read(databaseProvider).categories;
    await db.deleteOne(category);
  }

  Future<List<CategoryWithCount>> getCategoryWithCount() async {
    final query = ref.read(databaseProvider).getCategoryWithCount();

    return (query.map((row) {
      final category = (row.id != null)
          ? CategoryWithCount(
              count: row.amount,
              category: Category(
                id: row.id!,
                name: row.name!,
                color: row.color!,
              ),
            )
          : CategoryWithCount(count: row.amount, category: null);
      return category;
    })).get();
  }
}
