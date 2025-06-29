

import '../database/database.dart';

class CategoryWithCount {
  final Category? category;
  final int count;

  const CategoryWithCount({required this.category, required this.count});
}
