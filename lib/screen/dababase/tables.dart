import 'dart:ui';
export 'dart:ui' show Color;

import 'package:drift/drift.dart';

mixin AutoIncrementPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class Todos extends Table with AutoIncrementPrimaryKey {
  TextColumn get description => text()();
}

@DataClassName('Category')
class Categories extends Table with AutoIncrementPrimaryKey {
  TextColumn get name => text()();

  IntColumn get color => integer().map(ColorConvertor())();
}

class ColorConvertor extends TypeConverter<Color, int> {
  @override
  Color fromSql(int fromDb) {
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    return value.toARGB32();
  }
}
