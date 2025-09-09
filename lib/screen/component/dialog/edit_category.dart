import 'package:drift_todo_train/common/ui/component/custom_text_form_field.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void showEditCategory(BuildContext context, Category category) {
  showDialog(context: context, builder: (context) => _EditDialog(category));
}

class _EditDialog extends HookConsumerWidget {
  const _EditDialog(this.category);

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = useTextEditingController(text: category.name);
    return AlertDialog(
      title: Text('edit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [CustomTextFormField(controller: categoryController)],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(categoryServiceProvider.notifier)
                .updateCategory(
                  category.copyWith(name: categoryController.text),
                );
            context.pop();
          },
          child: Text('ok'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
