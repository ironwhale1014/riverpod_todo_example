import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_todo_train/model/category_with_count.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'database.dart';

part 'category_service.g.dart';

@riverpod
class CategoryService extends _$CategoryService {
  late final AppDatabase _database;

  @override
  void build() {
    _database = ref.watch(appDatabaseProvider);
    return;
  }

  Future<void> saveCategory(String categoryName) async {
    final random = Random();
    final randomColor =
        Colors.primaries[random.nextInt(Colors.primaries.length)];
    await _database.categories.insertOne(
      CategoriesCompanion.insert(name: categoryName, color: randomColor),
    );
  }

  Future<void> updateCategory(Category row) async {
    await _database.categories.replaceOne(row);
  }

  Future<void> deleteCategory(Category row) async {
    _database.transaction(() async {
      await (_database.todoEntries.update()
            ..where((todo) => todo.category.equals(row.id)))
          .write(TodoEntriesCompanion(category: Value(null)));
      await _database.categories.deleteOne(row);
    });
  }

  Stream<List<CategoryWithCount>> getCategoriesWithCount() {
    return _database.getCategoriesWithCount().map((row) {
      final category = (row.id != null)
          ? Category(id: row.id!, name: row.name!, color: row.color!)
          : null;
      return CategoryWithCount(category: category, count: row.amount);
    }).watch();
  }
}
