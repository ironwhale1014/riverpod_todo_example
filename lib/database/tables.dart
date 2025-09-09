import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/converter/color_converter.dart';

mixin PrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class TodoEntries extends Table with PrimaryKey {
  TextColumn get description => text()();

  DateTimeColumn get dueData => dateTime().nullable()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  IntColumn get category =>
      integer().nullable().references(CategoryEntries, #id)();
}

@DataClassName('CategoryEntry')
class CategoryEntries extends Table with PrimaryKey {
  TextColumn get name => text()();

  IntColumn get color => integer().map(const ColorConverter())();
}
