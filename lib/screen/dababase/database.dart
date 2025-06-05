import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/screen/dababase/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

Future<File> get getDatabaseFile async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'sqlite/train_two.db'));
}

@DriftDatabase(tables: [Categories, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          final file = await getDatabaseFile;
          return NativeDatabase.createInBackground(file);
        }),
      );

  @override
  int get schemaVersion => 1;
}
