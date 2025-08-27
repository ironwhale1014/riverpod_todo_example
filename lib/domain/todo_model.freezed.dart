// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoModel {

 int get id; String get description; DateTime? get dueDate; Category? get category;
/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoModelCopyWith<TodoModel> get copyWith => _$TodoModelCopyWithImpl<TodoModel>(this as TodoModel, _$identity);

  /// Serializes this TodoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,dueDate,category);

@override
String toString() {
  return 'TodoModel(id: $id, description: $description, dueDate: $dueDate, category: $category)';
}


}

/// @nodoc
abstract mixin class $TodoModelCopyWith<$Res>  {
  factory $TodoModelCopyWith(TodoModel value, $Res Function(TodoModel) _then) = _$TodoModelCopyWithImpl;
@useResult
$Res call({
 int id, String description, DateTime? dueDate, Category? category
});


$CategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$TodoModelCopyWithImpl<$Res>
    implements $TodoModelCopyWith<$Res> {
  _$TodoModelCopyWithImpl(this._self, this._then);

  final TodoModel _self;
  final $Res Function(TodoModel) _then;

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? dueDate = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,
  ));
}
/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodoModel].
extension TodoModelPatterns on TodoModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoModel value)  $default,){
final _that = this;
switch (_that) {
case _TodoModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoModel value)?  $default,){
final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String description,  DateTime? dueDate,  Category? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
return $default(_that.id,_that.description,_that.dueDate,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String description,  DateTime? dueDate,  Category? category)  $default,) {final _that = this;
switch (_that) {
case _TodoModel():
return $default(_that.id,_that.description,_that.dueDate,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String description,  DateTime? dueDate,  Category? category)?  $default,) {final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
return $default(_that.id,_that.description,_that.dueDate,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodoModel implements TodoModel {
  const _TodoModel({required this.id, required this.description, this.dueDate, this.category});
  factory _TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);

@override final  int id;
@override final  String description;
@override final  DateTime? dueDate;
@override final  Category? category;

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoModelCopyWith<_TodoModel> get copyWith => __$TodoModelCopyWithImpl<_TodoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,dueDate,category);

@override
String toString() {
  return 'TodoModel(id: $id, description: $description, dueDate: $dueDate, category: $category)';
}


}

/// @nodoc
abstract mixin class _$TodoModelCopyWith<$Res> implements $TodoModelCopyWith<$Res> {
  factory _$TodoModelCopyWith(_TodoModel value, $Res Function(_TodoModel) _then) = __$TodoModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String description, DateTime? dueDate, Category? category
});


@override $CategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$TodoModelCopyWithImpl<$Res>
    implements _$TodoModelCopyWith<$Res> {
  __$TodoModelCopyWithImpl(this._self, this._then);

  final _TodoModel _self;
  final $Res Function(_TodoModel) _then;

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? dueDate = freezed,Object? category = freezed,}) {
  return _then(_TodoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,
  ));
}

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
