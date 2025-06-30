import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_service.g.dart';

@riverpod
class CategoryService extends _$CategoryService {

  @override
  Category? build() {
    return null;
  }

  void changeCategory(Category? category) {
    state = category;
  }

  Future<void> updateCategory({required Category category}) async {
    await ref.watch(databaseProvider).categories.replaceOne(category);
  }

  // TODO: study it
  Future<void> saveCategory({required String name}) async {
    final findCategory =
        await (ref.watch(databaseProvider).categories.select()
              ..where((tbl) => tbl.name.equals(name)))
            .getSingleOrNull();

    if (findCategory == null) {
      final random = Random();

      final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      await ref.watch(databaseProvider).categories.insertOne(
        CategoriesCompanion.insert(name: name, color: color),
      );
    }
  }

  // TODO: study it
  Future<void> deleteCategory({required Category category}) async {
    ref.watch(databaseProvider).transaction(() async {
      await (ref.watch(databaseProvider).todoEntries.update()
            ..where((tbl) => tbl.category.equals(category.id)))
          .write(TodoEntriesCompanion(category: Value(null)));

      await ref.watch(databaseProvider).categories.deleteOne(category);
    });
  }

  Stream<List<CategoryWithCount>> getCategoryWithCount() {
    return (ref.watch(databaseProvider).getCategoryWithCount().map(
      (row) => CategoryWithCount(
        category: (row.id == null)
            ? null
            : Category(id: row.id!, name: row.name!, color: row.color!),
        count: row.amount,
      ),
    )).watch();
  }
}
