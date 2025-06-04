import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/database/connector/native.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
class DatabaseState extends _$DatabaseState {
  @override
  AppDatabase build() {
    return AppDatabase();
  }
}
@DriftDatabase(tables: [Todos, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase():super(
    LazyDatabase(() async {
      final file = await databaseFile;
      return NativeDatabase.createInBackground(file);
    })
  );
    
  @override
  int get schemaVersion => 1;

}
