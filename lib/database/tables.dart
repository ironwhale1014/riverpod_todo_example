import 'dart:ui';
export 'dart:ui' show Color;
import 'package:drift/drift.dart';

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

@DataClassName('TodoEntry')
class TodoEntries extends Table with AutoIncrementingPrimaryKey {
  TextColumn get description => text()();

  DateTimeColumn get dueDate => dateTime().nullable()();

  IntColumn get category => integer().nullable().references(Categories, #id)();
}

@DataClassName('Category')
class Categories extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();

  // We can use type converters to store custom classes in tables.
  // Here, we're storing colors as integers.
  IntColumn get color => integer().map(const ColorConverter())();
}

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  // ignore: deprecated_member_use
  int toSql(Color value) => value.value;
}
