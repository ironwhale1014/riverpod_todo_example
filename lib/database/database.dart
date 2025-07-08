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

@DriftDatabase(tables: [Categories, TodoEntries], include: {'sql.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          final file = await getDbFile;
          return NativeDatabase.createInBackground(file);
        }),
      );

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          logger.d('from1To2');
          await m.addColumn(schema.todoEntries, schema.todoEntries.category);
          await m.addColumn(schema.todoEntries, schema.todoEntries.isComplete);
          await m.alterTable(TableMigration(schema.todoEntries));
          logger.d('from1To2 end');
        },
        from2To3: (Migrator m, Schema3 schema) async {
          logger.d('from2To3 ');
          await m.createTable(schema.todoEntriesFts);
          await customStatement(
            'INSERT INTO todo_entries_fts(rowid,description) SELECT id, description FROM todo_entries;',
          );
          await m.create(schema.todoEntriesInsert);
          await m.create(schema.todoEntriesDelete);
          await m.create(schema.todoEntriesUpdate);
          logger.d('from2To3 end');
        },
      ),
    );
  }
}
