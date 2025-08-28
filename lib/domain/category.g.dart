// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  count: (json['count'] as num).toInt(),
  color: _$JsonConverterFromJson<int, Color>(
    json['color'],
    const ColorConverter().fromJson,
  ),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'count': instance.count,
  'color': _$JsonConverterToJson<int, Color>(
    instance.color,
    const ColorConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
