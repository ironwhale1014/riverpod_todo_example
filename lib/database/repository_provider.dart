import 'dart:math';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'database.dart';
import 'package:flutter/material.dart';

part 'repository_provider.g.dart';

@riverpod
class Repository extends _$Repository {
  late final AppDatabase database;

  @override
  void build() {
    database = ref.read(databaseStateProvider);
    return;
  }

  Future<int> saveTodos({required String description, int? categoryId}) async {
    return await database.todos.insertOne(
      TodosCompanion.insert(
        description: description,
        category: Value(categoryId),
      ),
    );
  }

  Future<void> updateTodos({required TodoEntry todo}) async {
    return await database.todos.replaceOne(todo);
  }

  Future<void> deleteTodos({required TodoEntry todo}) async {
    await database.todos.deleteOne(todo);
  }

  Future<TodoEntry?> findById({required int todoId}) async {
    return await (database.todos.select()
          ..where((tbl) => tbl.id.equals(todoId)))
        .getSingleOrNull();
  }

  Stream<List<TodoWithCategory>> todosInCategory(int? categoryId) {
    final query = database.todos.select().join([
      leftOuterJoin(
        database.categories,
        database.categories.id.equalsExp(database.todos.category),
      ),
    ]);

    if (categoryId != null) {
      query.where(database.categories.id.equals(categoryId));
    } else {
      query.where(database.categories.id.isNull());
    }

    return query
        .map(
          (row) => TodoWithCategory(
            todoEntry: row.readTable(database.todos),
            category: row.readTableOrNull(database.categories),
          ),
        )
        .watch();
  }

  Future<List<TodoWithCategory>> searchTodoWithCategory(String searchText) {
    return database
        .search(searchText)
        .map((row) => TodoWithCategory(todoEntry: row.todo, category: row.cat))
        .get();
  }

  Stream<List<CategoryWithCount>> getCategoryWithCount() {
    return database
        .getCategoriesWithCount()
        .map(
          (row) => CategoryWithCount(
            category: (row.id != null)
                ? Category(id: row.id!, name: row.name!, color: row.color!)
                : null,
            count: row.amount,
          ),
        )
        .watch();
  }

  Future<void> saveCategory(String category) async {
    final random = Random();
    final randomIndex = random.nextInt(Colors.primaries.length);
    await database.categories.insertOne(
      CategoriesCompanion.insert(
        name: category,
        color: Colors.primaries[randomIndex],
      ),
    );
  }
}

class TodoWithCategory {
  final TodoEntry todoEntry;
  final Category? category;

  TodoWithCategory({required this.todoEntry, this.category});
}

class CategoryWithCount {
  final Category? category;
  final int count;

  CategoryWithCount({this.category, required this.count});
}
