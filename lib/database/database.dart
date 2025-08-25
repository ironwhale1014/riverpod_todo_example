import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';


@DriftDatabase(tables: [Categories, TodoEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(LazyDatabase(_openConnection));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return NativeDatabase(await getDbFile());
  });
}

// 전역에서 단일 인스턴스를 재사용
final _appDbSingleton = AppDatabase();

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  ref.onDispose(() => _appDbSingleton.close());
  return _appDbSingleton;
}
