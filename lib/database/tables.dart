import 'dart:ui' show Color;

import 'package:drift/drift.dart';

mixin AutoIncrementPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class TodoEntries extends Table with AutoIncrementPrimaryKey {
  TextColumn get description => text()();

  DateTimeColumn get dueDate => dateTime().nullable()();

  IntColumn get category => integer().nullable().references(Categories, #id)();
}

@DataClassName('Category')
class Categories extends Table with AutoIncrementPrimaryKey {
  TextColumn get name => text().unique()();

  IntColumn get color => integer().map(ColorConverter())();

  IntColumn get category => integer().nullable().references(Categories, #id)();
}

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color fromSql(int fromDb) {
    // TODO: implement fromSql
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    return value.toARGB32();
  }
}
