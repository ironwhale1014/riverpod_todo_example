import 'package:drift_todo_train/common/components/custom_textfield.dart';
import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/util/logger.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    return DefaultLayout(
      title: 'Home Page',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CustomTextfield(
              controller: controller,
              hintText: 'Write Todo list ',
              onFieldSubmitted: (_) {
                logger.d(controller.text.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}
