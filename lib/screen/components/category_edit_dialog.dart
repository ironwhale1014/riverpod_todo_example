import 'package:drift_todo_train/common/components/custom_dialog.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryEditDialog extends ConsumerStatefulWidget {
  const CategoryEditDialog(this.category, {super.key});

  final Category category;

  @override
  ConsumerState createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends ConsumerState<CategoryEditDialog> {
  late final TextEditingController controller;
  Color? selectedColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(text: widget.category.name);
    selectedColor = widget.category.color;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      titleText: 'Edit it?',
      btnRightFunc: () async {
        final newCategory = widget.category.copyWith(
          name: controller.text.trim(),
          color: selectedColor,
        );
        await ref.read(categoryServiceProvider.notifier).update(newCategory);
        if (context.mounted) {
          context.pop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          TextFormField(controller: controller),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Change Category Color'),
              IconButton(
                onPressed: () async {
                  final color = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: BlockPicker(
                          pickerColor: selectedColor,
                          onColorChanged: (Color value) {
                            context.pop(value);
                          },
                        ),
                      );
                    },
                  );

                  if (selectedColor != null) {
                    setState(() {
                      selectedColor = color;
                    });
                  }
                },
                icon: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor,
                  ),
                  child: SizedBox.square(dimension: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
