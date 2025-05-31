// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodoEntriesTable extends TodoEntries
    with TableInfo<$TodoEntriesTable, TodoEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $TodoEntriesTable createAlias(String alias) {
    return $TodoEntriesTable(attachedDatabase, alias);
  }
}

class TodoEntry extends DataClass implements Insertable<TodoEntry> {
  final int id;
  final String description;
  const TodoEntry({required this.id, required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    return map;
  }

  TodoEntriesCompanion toCompanion(bool nullToAbsent) {
    return TodoEntriesCompanion(id: Value(id), description: Value(description));
  }

  factory TodoEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoEntry(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
    };
  }

  TodoEntry copyWith({int? id, String? description}) => TodoEntry(
    id: id ?? this.id,
    description: description ?? this.description,
  );
  TodoEntry copyWithCompanion(TodoEntriesCompanion data) {
    return TodoEntry(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntry(')
          ..write('id: $id, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoEntry &&
          other.id == this.id &&
          other.description == this.description);
}

class TodoEntriesCompanion extends UpdateCompanion<TodoEntry> {
  final Value<int> id;
  final Value<String> description;
  const TodoEntriesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
  });
  TodoEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
  }) : description = Value(description);
  static Insertable<TodoEntry> custom({
    Expression<int>? id,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
    });
  }

  TodoEntriesCompanion copyWith({Value<int>? id, Value<String>? description}) {
    return TodoEntriesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntriesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoEntriesTable todoEntries = $TodoEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todoEntries];
}

typedef $$TodoEntriesTableCreateCompanionBuilder =
    TodoEntriesCompanion Function({Value<int> id, required String description});
typedef $$TodoEntriesTableUpdateCompanionBuilder =
    TodoEntriesCompanion Function({Value<int> id, Value<String> description});

class $$TodoEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TodoEntriesTable> {
  $$TodoEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoEntriesTable> {
  $$TodoEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoEntriesTable> {
  $$TodoEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$TodoEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoEntriesTable,
          TodoEntry,
          $$TodoEntriesTableFilterComposer,
          $$TodoEntriesTableOrderingComposer,
          $$TodoEntriesTableAnnotationComposer,
          $$TodoEntriesTableCreateCompanionBuilder,
          $$TodoEntriesTableUpdateCompanionBuilder,
          (
            TodoEntry,
            BaseReferences<_$AppDatabase, $TodoEntriesTable, TodoEntry>,
          ),
          TodoEntry,
          PrefetchHooks Function()
        > {
  $$TodoEntriesTableTableManager(_$AppDatabase db, $TodoEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => TodoEntriesCompanion(id: id, description: description),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
              }) =>
                  TodoEntriesCompanion.insert(id: id, description: description),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoEntriesTable,
      TodoEntry,
      $$TodoEntriesTableFilterComposer,
      $$TodoEntriesTableOrderingComposer,
      $$TodoEntriesTableAnnotationComposer,
      $$TodoEntriesTableCreateCompanionBuilder,
      $$TodoEntriesTableUpdateCompanionBuilder,
      (TodoEntry, BaseReferences<_$AppDatabase, $TodoEntriesTable, TodoEntry>),
      TodoEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoEntriesTableTableManager get todoEntries =>
      $$TodoEntriesTableTableManager(_db, _db.todoEntries);
}
