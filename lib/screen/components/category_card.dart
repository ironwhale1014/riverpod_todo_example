import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:drift_todo_train/screen/components/custom_dialog.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard(this.categoryWithCount, {super.key});

  final CategoryWithCount categoryWithCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = categoryWithCount.category;
    final count = categoryWithCount.count;
    final isActive = category == ref.watch(categoryStateProvider);

    final rowData = [
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category?.color ?? Colors.blueAccent[100],
        ),
        child: SizedBox.square(dimension: 20),
      ),
      Expanded(child: Text(category?.name ?? '기본')),
      Text('$count 개'),
    ];

    if (category != null) {
      rowData.addAll([
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _DeleteOrEditDialog(category),
            );
          },
          icon: Icon(Icons.more_vert),
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: isActive
            ? Colors.orangeAccent.withValues(alpha: 255 * 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(spacing: 8, children: rowData),
        ),
      ),
    );
  }
}

class _DeleteOrEditDialog extends ConsumerWidget {
  const _DeleteOrEditDialog(this.category);

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => CustomDialog.withBtn(
                  title: 'Delete it??',
                  leftBtnOnPressed: () {
                    context.pop();
                  },
                  rightBtnOnPressed: () async {
                    context.pop();
                    await ref
                        .read(categoryServiceProvider.notifier)
                        .deleteCategory(category);
                  },
                ),
              );
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text('삭제 하기'),
          ),
          TextButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return _EditDialog(category: category);
                },
              );
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text('수정 하기'),
          ),
        ],
      ),
    );
  }
}

class _EditDialog extends ConsumerStatefulWidget {
  const _EditDialog({required this.category});

  final Category category;

  @override
  ConsumerState createState() => __EditDialogState();
}

class __EditDialogState extends ConsumerState<_EditDialog> {
  final controller = TextEditingController();
  late final Category category;

  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    category = widget.category;
    controller.text = category.name;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog.withBtn(
      title: 'EDIT it??',

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(controller: controller),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Category color'),
              InkWell(
                onTap: () async {
                  final pickColor = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: BlockPicker(
                          pickerColor: category.color,
                          onColorChanged: (Color value) => context.pop(value),
                        ),
                      );
                    },
                  );
                  if (pickColor != null) {
                    setState(() {
                      selectedColor = pickColor;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor ?? category.color,
                  ),
                  child: SizedBox.square(dimension: 20),
                ),
              ),
            ],
          ),
        ],
      ),
      leftBtnOnPressed: () {
        context.pop();
      },
      rightBtnOnPressed: () async {
        context.pop();
        await ref
            .read(categoryServiceProvider.notifier)
            .updateCategory(
              category.copyWith(
                name: controller.text.trim(),
                color: selectedColor ?? category.color,
              ),
            );
      },
    );
  }
}
