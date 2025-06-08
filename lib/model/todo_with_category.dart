import 'package:drift_todo_train/database/database.dart';

class TodoWithCategory {
  final TodoEntry todoEntry;
  final Category? category;

  TodoWithCategory({required this.todoEntry, this.category});
}

