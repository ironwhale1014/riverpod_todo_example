import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/util/logger.dart';

part 'category_repository.g.dart';

@riverpod
CategoryDao categoryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao;
}

@DriftAccessor(tables: [CategoryEntries, TodoEntries])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

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

  Future<Category> getCategoryById(int? categoryId) async {
    try {
      final query = selectOnly(todoEntries)
        ..addColumns([todoEntries.id.count()]);

      CategoryEntry? categoryEntry;
      int count = 0;

      if (categoryId != null) {
        categoryEntry = await (select(
          categoryEntries,
        )..where((e) => e.id.equals(categoryId))).getSingle();

        final countResult =
            await (query..where(todoEntries.category.equals(categoryId)))
                .getSingle();
        count = countResult.read(todoEntries.id.count()) ?? 0;
      }

      return Category(
        id: categoryEntry?.id,
        name: categoryEntry?.name,
        count: count,
        color: categoryEntry?.color,
      );
    } catch (e, s) {
      logger.e('getCategoryById failed: id=$categoryId', e, s);
      rethrow;
    }
  }

  Future<void> deleteCategory(Category category) async {
    db.transaction(() async {
      await (db.todoEntries.update()
            ..where((todo) => todo.category.equals(category.id!)))
          .write(TodoEntriesCompanion(category: Value(null)));
      await (delete(
        categoryEntries,
      )..where((filter) => filter.id.equals(category.id!))).go();
    });
  }

  Future<void> updateCategory(Category category) async {
    await (update(
      categoryEntries,
    )..where((filter) => filter.id.equals(category.id!))).write(
      CategoryEntriesCompanion.insert(
        name: category.name!,
        color: category.color!,
      ),
    );
  }

  Future<Category> createCategory({required String name}) async {
    final random = Random();
    final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    final id = await categoryEntries.insertOne(
      CategoryEntriesCompanion.insert(name: name, color: color),
    );

    return getCategoryById(id);
  }
}
