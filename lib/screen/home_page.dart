import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '홈',
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (_) {
          ref
              .read(todoServiceProvider.notifier)
              .saveTodo(controller.text.trim());
          controller.clear();
        },
      ),
    );
  }
}
