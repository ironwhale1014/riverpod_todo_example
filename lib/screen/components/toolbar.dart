import 'package:drift_todo_train/service/todo_list_filter_state_provider.dart';
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
                  .read(todoListFilterStateProvider.notifier)
                  .setFilter(TodoListFilter.all);
            },
            child: Text('ALL'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterStateProvider.notifier)
                  .setFilter(TodoListFilter.active);
            },
            child: Text('Uncompleted'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterStateProvider.notifier)
                  .setFilter(TodoListFilter.completed);
            },
            child: Text('Completed'),
          ),
        ],
      ),
    );
  }
}
