import 'package:drift_todo_train/service/filter_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Toolbar extends ConsumerWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilterStateProvider);
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterStateProvider.notifier)
                  .setFilter(TodoListFilter.all);
            },
            child: Text(
              'ALL',
              style: TextStyle(
                color: filter == TodoListFilter.all
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterStateProvider.notifier)
                  .setFilter(TodoListFilter.uncompleted);
            },
            child: Text(
              'Uncompleted',
              style: TextStyle(
                color: filter == TodoListFilter.uncompleted
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterStateProvider.notifier)
                  .setFilter(TodoListFilter.completed);
            },
            child: Text(
              'Completed',
              style: TextStyle(
                color: filter == TodoListFilter.completed
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
