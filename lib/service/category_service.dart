import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_service.g.dart';

@riverpod
class CategoryState extends _$CategoryState {
  @override
  Category? build() {
    return null;
  }

  void changeCategory(Category? category) {
    state = category;
  }
}

@riverpod
class CategoryService extends _$CategoryService {
  @override
  Category? build() {
    return null;
  }

  Future<void> saveCategory({required String name}) async {
    final random = Random(42);
    final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    await ref
        .read(databaseProvider)
        .categories
        .insertOne(CategoriesCompanion.insert(name: name, color: color));
  }

  Future<void> deleteCategory(Category category) async {
    final database = ref.read(databaseProvider);
    database.transaction(() async {
      await (database.todoEntries.update()
            ..where((row) => row.category.equals(category.id)))
          .write(TodoEntriesCompanion(category: Value(null)));

      await database.categories.deleteOne(category);
    });
  }

  Future<void> updateCategory(Category category) async {
    final database = ref.read(databaseProvider);
    await database.categories.replaceOne(category);
  }

  Stream<List<CategoryWithCount>> getCategories() {
    return ref
        .read(databaseProvider)
        .getCategoryWithCount()
        .map(
          (row) => CategoryWithCount(
            category: row.id != null
                ? Category(id: row.id!, name: row.name!, color: row.color!)
                : null,
            count: row.amount,
          ),
        )
        .watch();
  }
}
