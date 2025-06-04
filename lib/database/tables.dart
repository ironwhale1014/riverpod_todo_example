import 'dart:ui';
import 'package:drift/drift.dart';

mixin AutoPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class Todos extends Table with AutoPrimaryKey {
  //schemaVersion 1
  TextColumn get description => text()();
}

@DataClassName('Category')
class Categories extends Table with AutoPrimaryKey {
  //schemaVersion 1
  TextColumn get name => text()();

  IntColumn get color => integer().map(const ColorConvertor())();
}

class ColorConvertor extends TypeConverter<Color, int> {
  const ColorConvertor();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.toARGB32();
}
