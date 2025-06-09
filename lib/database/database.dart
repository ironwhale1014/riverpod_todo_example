import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/logger.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
class DatabaseState extends _$DatabaseState {
  @override
  AppDatabase build() {
    return AppDatabase();
  }
}

@DriftDatabase(tables: [TodoEntries, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        logger.d('from1To2');
        await m.alterTable(TableMigration(schema.todoEntries));
        logger.d('from1To2 end');
      },
    ),
    beforeOpen: (details) async {},
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await myDatabaseFile;
    return NativeDatabase.createInBackground(file);
  });
}

Future<File> get myDatabaseFile async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, 'my_db.sqlite'));
}
