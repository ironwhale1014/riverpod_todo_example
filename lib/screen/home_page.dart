import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: 'Home Page',
      child: Column(
        children: [
          TextFormField(controller: controller, onFieldSubmitted: (_) {}),
        ],
      ),
    );
  }
}
