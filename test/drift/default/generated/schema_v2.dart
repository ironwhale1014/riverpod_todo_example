// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class CategoryEntries extends Table
    with TableInfo<CategoryEntries, CategoryEntriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CategoryEntries(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_entries';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntriesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  CategoryEntries createAlias(String alias) {
    return CategoryEntries(attachedDatabase, alias);
  }
}

class CategoryEntriesData extends DataClass
    implements Insertable<CategoryEntriesData> {
  final int id;
  final String name;
  final int color;
  const CategoryEntriesData({
    required this.id,
    required this.name,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  CategoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return CategoryEntriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  factory CategoryEntriesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntriesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  CategoryEntriesData copyWith({int? id, String? name, int? color}) =>
      CategoryEntriesData(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  CategoryEntriesData copyWithCompanion(CategoryEntriesCompanion data) {
    return CategoryEntriesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntriesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntriesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class CategoryEntriesCompanion extends UpdateCompanion<CategoryEntriesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  const CategoryEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int color,
  }) : name = Value(name),
       color = Value(color);
  static Insertable<CategoryEntriesData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  CategoryEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? color,
  }) {
    return CategoryEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class TodoEntries extends Table with TableInfo<TodoEntries, TodoEntriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TodoEntries(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> dueData = GeneratedColumn<DateTime>(
    'due_data',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category_entries (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    description,
    dueData,
    isDone,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_entries';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoEntriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoEntriesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      dueData: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_data'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category'],
      ),
    );
  }

  @override
  TodoEntries createAlias(String alias) {
    return TodoEntries(attachedDatabase, alias);
  }
}

class TodoEntriesData extends DataClass implements Insertable<TodoEntriesData> {
  final int id;
  final String description;
  final DateTime? dueData;
  final bool isDone;
  final int? category;
  const TodoEntriesData({
    required this.id,
    required this.description,
    this.dueData,
    required this.isDone,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || dueData != null) {
      map['due_data'] = Variable<DateTime>(dueData);
    }
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(category);
    }
    return map;
  }

  TodoEntriesCompanion toCompanion(bool nullToAbsent) {
    return TodoEntriesCompanion(
      id: Value(id),
      description: Value(description),
      dueData: dueData == null && nullToAbsent
          ? const Value.absent()
          : Value(dueData),
      isDone: Value(isDone),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory TodoEntriesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoEntriesData(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      dueData: serializer.fromJson<DateTime?>(json['dueData']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      category: serializer.fromJson<int?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'dueData': serializer.toJson<DateTime?>(dueData),
      'isDone': serializer.toJson<bool>(isDone),
      'category': serializer.toJson<int?>(category),
    };
  }

  TodoEntriesData copyWith({
    int? id,
    String? description,
    Value<DateTime?> dueData = const Value.absent(),
    bool? isDone,
    Value<int?> category = const Value.absent(),
  }) => TodoEntriesData(
    id: id ?? this.id,
    description: description ?? this.description,
    dueData: dueData.present ? dueData.value : this.dueData,
    isDone: isDone ?? this.isDone,
    category: category.present ? category.value : this.category,
  );
  TodoEntriesData copyWithCompanion(TodoEntriesCompanion data) {
    return TodoEntriesData(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueData: data.dueData.present ? data.dueData.value : this.dueData,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntriesData(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('dueData: $dueData, ')
          ..write('isDone: $isDone, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description, dueData, isDone, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoEntriesData &&
          other.id == this.id &&
          other.description == this.description &&
          other.dueData == this.dueData &&
          other.isDone == this.isDone &&
          other.category == this.category);
}

class TodoEntriesCompanion extends UpdateCompanion<TodoEntriesData> {
  final Value<int> id;
  final Value<String> description;
  final Value<DateTime?> dueData;
  final Value<bool> isDone;
  final Value<int?> category;
  const TodoEntriesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.dueData = const Value.absent(),
    this.isDone = const Value.absent(),
    this.category = const Value.absent(),
  });
  TodoEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.dueData = const Value.absent(),
    this.isDone = const Value.absent(),
    this.category = const Value.absent(),
  }) : description = Value(description);
  static Insertable<TodoEntriesData> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<DateTime>? dueData,
    Expression<bool>? isDone,
    Expression<int>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (dueData != null) 'due_data': dueData,
      if (isDone != null) 'is_done': isDone,
      if (category != null) 'category': category,
    });
  }

  TodoEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<DateTime?>? dueData,
    Value<bool>? isDone,
    Value<int?>? category,
  }) {
    return TodoEntriesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      dueData: dueData ?? this.dueData,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueData.present) {
      map['due_data'] = Variable<DateTime>(dueData.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntriesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('dueData: $dueData, ')
          ..write('isDone: $isDone, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final CategoryEntries categoryEntries = CategoryEntries(this);
  late final TodoEntries todoEntries = TodoEntries(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoryEntries,
    todoEntries,
  ];
  @override
  int get schemaVersion => 2;
}
