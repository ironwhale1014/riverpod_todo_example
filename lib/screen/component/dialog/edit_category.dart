import 'package:drift_todo_train/common/ui/component/custom_text_form_field.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

    final colorState = useState<Color?>(category.color);

    return AlertDialog(
      title: Text('Edit Category', textAlign: TextAlign.center),
      content: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(controller: categoryController),
          IconButton(
            onPressed: () async {
              final selectedColor = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: BlockPicker(
                      pickerColor: colorState.value,
                      onColorChanged: (value) {
                        context.pop(value);
                      },
                    ),
                  );
                },
              );

              if (selectedColor != null) {
                colorState.value = selectedColor;
              }
            },
            icon: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorState.value,
              ),
              child: SizedBox.square(dimension: 24),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('NO'),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(categoryServiceProvider.notifier)
                .updateCategory(
                  category.copyWith(
                    name: categoryController.text,
                    color: colorState.value,
                  ),
                );
            context.pop();
          },
          child: Text('OK'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
