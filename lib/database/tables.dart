import 'dart:ui';
export 'dart:ui' show Color;
import 'package:drift/drift.dart';

mixin PrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class TodoEntries extends Table with PrimaryKey {
  TextColumn get description => text()();
}

@DataClassName('Category')
class Categories extends Table with PrimaryKey {
  TextColumn get name => text()();

  IntColumn get color => integer().map(ColorConverter())();
}

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color fromSql(int fromDb) {
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    return value.toARGB32();
  }
}
