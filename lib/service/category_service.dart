import 'dart:math';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_service.g.dart';

@riverpod
class CategoryService extends _$CategoryService {
  late final AppDatabase _dateBase;

  @override
  Category? build() {
    _dateBase = ref.watch(databaseProvider);
    return null;
  }

  void changeCategory(Category? category) {
    state = category;
  }

  Future<void> updateCategory({required Category category}) async {
    await _dateBase.categories.replaceOne(category);
  }

  Future<void> saveCategory({required String name}) async {
    final findCategory =
        await (_dateBase.categories.select()
              ..where((tbl) => tbl.name.equals(name)))
            .getSingleOrNull();

    if (findCategory == null) {
      final random = Random();

      final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      await _dateBase.categories.insertOne(
        CategoriesCompanion.insert(name: name, color: color),
      );
    }
  }

  Future<void> deleteCategory({required Category category}) async {
    _dateBase.transaction(() async {
      await (_dateBase.todoEntries.update()
            ..where((tbl) => tbl.category.equals(category.id)))
          .write(TodoEntriesCompanion(category: Value(null)));

      await _dateBase.categories.deleteOne(category);
    });
  }

  Stream<List<CategoryWithCount>> getCategoryWithCount() {
    return (_dateBase.getCategoryWithCount().map(
      (row) => CategoryWithCount(
        category: (row.id == null)
            ? null
            : Category(id: row.id!, name: row.name!, color: row.color!),
        count: row.amount,
      ),
    )).watch();
  }
}
