import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/database_util.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/util/logger.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
class DatabaseState extends _$DatabaseState {
  @override
  AppDataBase build() {
    return AppDataBase();
  }
}

@DriftDatabase(tables: [TodoEntries, Categories])
class AppDataBase extends _$AppDataBase {
  AppDataBase()
    : super(
        LazyDatabase(() async {
          return NativeDatabase.createInBackground(await getDatabaseFile);
        }),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          logger.d('from1To2');
          await m.alterTable(TableMigration(schema.todoEntries));
          logger.d('from1To2 end');
        },
      ),

      beforeOpen: (details) async {
        logger.d(details.versionNow);
      },
    );
  }
}
