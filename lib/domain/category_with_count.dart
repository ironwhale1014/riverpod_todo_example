

import 'package:drift_todo_train/database/database.dart';

class CategoryWithCount{
  final Category? category;
  final int count;

  CategoryWithCount({this.category, required this.count});
}