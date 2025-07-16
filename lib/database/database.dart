import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TodoEntries, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          return NativeDatabase.createInBackground(await getDbFile);
        }),
      );

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;
}
