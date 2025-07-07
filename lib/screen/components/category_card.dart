import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:drift_todo_train/screen/components/custom_dialog.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          icon: Icon(Icons.list),
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
            child: Text('수정 하기'),
          ),
        ],
      ),
    );
  }
}
