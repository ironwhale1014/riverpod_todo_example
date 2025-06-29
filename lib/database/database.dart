import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/util/logger.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase();
}

@DriftDatabase(tables: [TodoEntries, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final file = await getDbFile;
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        logger.d("from1To2");
        await m.addColumn(schema.todoEntries, schema.todoEntries.category);
        await m.alterTable(TableMigration(schema.todoEntries));
        logger.d("from1To2 end");
      },
    ),
    beforeOpen: (details) async {},
  );
}
