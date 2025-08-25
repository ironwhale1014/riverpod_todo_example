import 'dart:ui' show Color;
export 'dart:ui' show Color;

import 'package:drift/drift.dart';

mixin PrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class TodoEntries extends Table with PrimaryKey {
  TextColumn get description => text()();

  DateTimeColumn get dueData => dateTime().nullable()();

  IntColumn get category => integer().nullable().references(Categories, #id)();
}

@DataClassName('Category')
class Categories extends Table with PrimaryKey {
  TextColumn get name => text()();

  IntColumn get color => integer().map(ColorConverter())();
}

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.toARGB32();
}
