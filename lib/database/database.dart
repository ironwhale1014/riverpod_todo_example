import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/util/logger.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
class DatabaseState extends _$DatabaseState {
  @override
  AppDatabase build() {
    return AppDatabase();
  }

  void restartDb() async {
    final old = state;
    await old.close();
    state = AppDatabase();
  }
}

@DriftDatabase(tables: [Categories, TodoEntries], include: {'sql.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            LazyDatabase(() async {
              final file = await getDbFile;
              return NativeDatabase.createInBackground(file);
            }),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          logger.d('from1To2');
          await m.addColumn(schema.todoEntries, schema.todoEntries.category);
          await m.alterTable(TableMigration(schema.todoEntries));
          logger.d('from1To2 end');
        },
        from2To3: (Migrator m, Schema3 schema) async {
          logger.d('from2To3');
          await m.createTable(schema.todoEntriesFts);
          await m.create(schema.todoEntriesAd);
          await m.create(schema.todoEntriesAi);
          await m.create(schema.todoEntriesAu);
          await customStatement(
            'INSERT INTO todo_entries_fts(rowid, description) SELECT id, description FROM todo_entries;',
          );
          logger.d('from2To3 end');
        },
      ),

      beforeOpen: (details) async {
        logger.d(details.versionNow);
        logger.d(details.versionBefore);
      },
    );
  }
}
