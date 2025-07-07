import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Categories, TodoEntries])
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
  int get schemaVersion => 1;
}
