import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

Future<File> get _getDbFile async {
  final dirPath = await getApplicationDocumentsDirectory();
  return File(p.join(dirPath.path, 'train3.db'));
}

@DriftDatabase(tables: [Categories, TodoEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          return NativeDatabase.createInBackground(await _getDbFile);
        }),
      );

  @override
  int get schemaVersion => 1;
}
