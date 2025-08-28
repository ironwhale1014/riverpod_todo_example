import 'dart:ui';

import 'package:drift_todo_train/database/converter/color_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int? id,
    required String? name,
    required int count,
    @ColorConverter() required Color? color,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) =>
      _$CategoryFromJson(json);
}
