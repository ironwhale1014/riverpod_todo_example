import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:drift_todo_train/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_service.g.dart';

@riverpod
class CategoryService extends _$CategoryService {
  @override
  BaseModel<CategoryWithCount> build() {
    paginate();
    return Loading();
  }

  Future<void> save({required String name}) async {
    if (name.trim() == '기본') {
      return;
    }
    final random = Random();
    final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    await ref
        .read(categoryRepositoryProvider.notifier)
        .save(CategoriesCompanion.insert(name: name, color: color));

    if (state is Model) {
      await paginate();
    }
  }

  Future<void> paginate() async {
    final datas = await ref
        .read(categoryRepositoryProvider.notifier)
        .getCategoryWithCount();

    logger.d('paginate: ${datas.length}');

    state = Model(datas);
  }

  Future<void> update(Category category) async {
    final db = ref.read(databaseProvider);
    await db.categories.replaceOne(category);
    paginate();
  }

  Future<void> delete(Category category) async {
    logger.d('delete category: ${category.name}');
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      await (db.todoEntries.update()
            ..where((todo) => todo.category.equals(category.id)))
          .write(TodoEntriesCompanion(category: Value(null)));

      await db.categories.deleteOne(category);

      if (state is Model) {
        await paginate();
        logger.d('paginate in delete');
      }
    });
  }
}
