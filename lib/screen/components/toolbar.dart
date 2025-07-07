import 'package:drift_todo_train/service/category_filter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Toolbar extends ConsumerWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterNotifierProvider.notifier)
                  .setFilter(TodoListFilter.all);
            },
            child: Text('ALL'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterNotifierProvider.notifier)
                  .setFilter(TodoListFilter.active);
            },
            child: Text('Uncompleted'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterNotifierProvider.notifier)
                  .setFilter(TodoListFilter.completed);
            },
            child: Text('Completed'),
          ),
        ],
      ),
    );
  }
}
