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

Future<File> get getDatabaseFile async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'sqlite/train_two.db'));
}

@Riverpod(keepAlive: true)
class DatabaseState extends _$DatabaseState {
  @override
  AppDatabase build() {
    return AppDatabase();
  }
}

@DriftDatabase(tables: [Categories, Todos], include: {'sql.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          final file = await getDatabaseFile;
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
          await m.addColumn(schema.todos, schema.todos.dueDate);
          await m.alterTable(TableMigration(schema.todos));
        },
        from2To3: (Migrator m, Schema3 schema) async {
          logger.d('from2To3');
          await m.createTable(schema.testEntries);
          logger.d("test_entries created");
          await customStatement(
            'INSERT INTO test_entries(rowid, description) SELECT id, description FROM todos;',
          );
          logger.d('from2To3 end');
        },
      ),
    );
  }
}
