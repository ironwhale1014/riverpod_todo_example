import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/database/connector/native.dart';
import 'package:drift_todo_train/database/database.steps.dart';
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
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            LazyDatabase(() async {
              final file = await databaseFile;
              return NativeDatabase.createInBackground(file);
            }),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.addColumn(schema.todos, schema.todos.dueDate);
          await m.addColumn(schema.todos, schema.todos.category);

          await m.alterTable(TableMigration(schema.todos));
        },
      ),
    );
  }

  // Stream<List<TodoWithCategory>> todosInCategory(int? categoryId){
  //
  //   final query = select(todos).join([
  //     leftOuterJoin(categories, categories.id.equalsExp(todos.cat))
  //   ]);
  //
  //
  // }
}

class TodoWithCategory {
  final TodoEntry todo;
  final Category? category;

  TodoWithCategory(this.todo, this.category);
}
