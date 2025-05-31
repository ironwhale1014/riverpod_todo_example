import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(tables: [TodoEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          final folder = await getApplicationDocumentsDirectory();
          final file = File(p.join(folder.path, 'sqlite/my_db.db'));
          return NativeDatabase.createInBackground(file);
        }),
      );

  @override
  int get schemaVersion => 1;
}
