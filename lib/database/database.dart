import 'dart:ui' show Color;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/converter/color_converter.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:drift_todo_train/repository/category_repository.dart';
import 'package:drift_todo_train/repository/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [CategoryEntries, TodoEntries],
  daos: [TodoDao, CategoryDao], // DAO 추가
  include: {'sql.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? LazyDatabase(_openConnection));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          logger.d('from1To2');
          m.addColumn(schema.todoEntries, schema.todoEntries.isDone);
          logger.d('from1To2 end');
        },
      ),
    );
  }
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
