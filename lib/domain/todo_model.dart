import 'package:drift_todo_train/database/database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drift_todo_train/domain/category.dart';

part 'todo_model.freezed.dart';

part 'todo_model.g.dart';

@freezed
abstract class TodoModel with _$TodoModel {
  const factory TodoModel({
    required int id,
    required String description,
    DateTime? dueDate,
    Category? category,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, Object?> json) =>
      _$TodoModelFromJson(json);

  factory TodoModel.fromTbl(TodoEntry entry, Category? category) {
    return TodoModel(
      id: entry.id,
      description: entry.description,
      category: category,
    );
  }
}
