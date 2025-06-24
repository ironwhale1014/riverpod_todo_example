import 'dart:io';
import 'dart:ui' show Color;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

Future<File> get _getDbFile async {
  final dirPath = await getApplicationDocumentsDirectory();
  return File(p.join(dirPath.path, 'train3.db'));
}

@Riverpod(keepAlive: true)
class Database extends _$Database {
  @override
  AppDatabase build() {
    return AppDatabase();
  }
}

@DriftDatabase(tables: [Categories, TodoEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          logger.d(await _getDbFile);

          return NativeDatabase.createInBackground(await _getDbFile);
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
    );
  }
}
