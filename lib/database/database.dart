import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase();
}

@DriftDatabase(tables: [TodoEntries, Categories], include: {'sql.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            LazyDatabase(() async {
              return NativeDatabase.createInBackground(await getDbFile);
            }),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          logger.d("from1To2");
          await m.addColumn(schema.todoEntries, schema.todoEntries.category);
          await m.alterTable(TableMigration(schema.todoEntries));
          logger.d("from1To2 end");
        },
      ),
    );
  }
}

// INFO: default: Generated test in test/drift/default/migration_test.dart.
// Run this test to validate that your migrations are written correctly. flutter test test/drift/default/migration_test.dart
// INFO: Running this test requires changes to your database class! The database needs to support being opened against custom databasesfor testing. To do that, change the constructor of your database from e.g.
// AppDatabase(): super(_openConnection());
// to something like:
// AppDatabase([QueryExecutor? e]): super(e ?? _openConnection());
