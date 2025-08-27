import 'dart:ui';

import 'package:drift_todo_train/database/converter/color_converter.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    @ColorConverter() required Color color,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) =>
      _$CategoryFromJson(json);

  factory Category.fromTbl(CategoryEntry entry) {
    return Category(id: entry.id, name: entry.name, color: entry.color);
  }
}
