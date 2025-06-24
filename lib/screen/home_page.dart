import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: 'home',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: controller,
              onFieldSubmitted: (_) {
                if (controller.text.isNotEmpty) {
                  controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
