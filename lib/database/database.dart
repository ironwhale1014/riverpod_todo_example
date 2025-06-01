import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_todo_train/database/database.steps.dart';
import 'package:drift_todo_train/database/tables.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

@DriftDatabase(tables: [TodoEntries], include: {'sql.drift'})
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
  int get schemaVersion => 5;

  @override
  // TODO: implement migration
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.addColumn(schema.todoEntries, schema.todoEntries.dueDate);
        },
        from2To3: (m, schema) async {
          await m.create(schema.todosDelete);
          await m.create(schema.todosUpdate);
          await m.alterTable(TableMigration(schema.todoEntries));
        },
        from3To4: (m, schema) async {
          await m.createTable(schema.categories);
        },
        from4To5: (m, schema) async {
          await m.alterTable(TableMigration(schema.todoEntries));
        },
      ),
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        if (details.wasCreated) {
          // Create a bunch of default values so the app doesn't look too empty
          // on the first start.
          await batch((b) {
            b.insert(
              categories,
              CategoriesCompanion.insert(name: 'Important', color: Colors.red),
            );

            b.insertAll(todoEntries, [
              TodoEntriesCompanion.insert(description: 'Check out drift'),
              TodoEntriesCompanion.insert(
                description: 'Fix session invalidation bug',
                category: const Value(1),
              ),
              TodoEntriesCompanion.insert(
                description: 'Add favorite movies to home page',
              ),
            ]);
          });
        }
      },
    );
  }

  Stream<List<TodoEntryWithCategory>> entriesInCategory(int? categoryId) {
    final query = select(todoEntries).join([
      leftOuterJoin(categories, categories.id.equalsExp(todoEntries.category)),
    ]);
    if (categoryId != null) {
      query.where(categories.id.equals(categoryId));
    } else {
      query.where(categories.id.isNull());
    }

    return query.map((row) {
      return TodoEntryWithCategory(
        todoEntry: row.readTable(todoEntries),
        category: row.readTableOrNull(categories),
      );
    }).watch();
  }
}

class TodoEntryWithCategory {
  final TodoEntry todoEntry;
  final Category? category;

  TodoEntryWithCategory({required this.todoEntry, required this.category});
}
