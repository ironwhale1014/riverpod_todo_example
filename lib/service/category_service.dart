import 'dart:math';

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
    final random = Random();
    final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    await ref
        .read(categoryRepositoryProvider.notifier)
        .save(CategoriesCompanion.insert(name: name, color: color));

    if (state is Model) {
      paginate();
    }
  }

  Future<void> paginate() async {
    final datas = await ref
        .read(categoryRepositoryProvider.notifier)
        .getCategoryWithCount();

    state = Model(datas);
  }
}
