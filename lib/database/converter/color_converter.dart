import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter extends TypeConverter<Color, int>
    implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) {
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    return value.toARGB32();
  }

  @override
  Color fromJson(int json) {
    return Color(json);
  }

  @override
  int toJson(Color object) {
    return object.toARGB32();
  }
}
