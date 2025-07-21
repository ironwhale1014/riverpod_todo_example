import 'package:drift_todo_train/common/components/common_listview.dart';
import 'package:drift_todo_train/common/components/more_options_button.dart';
import 'package:drift_todo_train/common/components/custom_textfield.dart';
import 'package:drift_todo_train/common/util/dialog_utils.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:drift_todo_train/screen/components/category_edit_dialog.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/category_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyDrawer extends ConsumerWidget {
  MyDrawer({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            DrawerHeader(child: Text('Category')),
            CustomTextfield(
              controller: controller,
              hintText: 'Write Category',
              onFieldSubmitted: (_) async {
                ref
                    .read(categoryServiceProvider.notifier)
                    .save(name: controller.text.trim());
                controller.clear();
              },
            ),
            Expanded(
              child: CommonListview<CategoryWithCount, BaseModel>(
                provider: categoryServiceProvider,
                itemBuilder: (context, index, model) =>
                    _CategoryDrawerEntry(categoryWithCount: model),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDrawerEntry extends ConsumerWidget {
  const _CategoryDrawerEntry({required this.categoryWithCount});

  final CategoryWithCount categoryWithCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(categoryStateProviderProvider)?.id ==
        categoryWithCount.category?.id;
    final rowData = [
      DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: categoryWithCount.category?.color ?? Colors.white,
        ),
        child: SizedBox.square(dimension: 20),
      ),
      SizedBox(width: 16),
      Expanded(child: Text(categoryWithCount.category?.name ?? '기본')),
      Text('${categoryWithCount.count} 개'),
    ];

    if (categoryWithCount.category != null) {
      rowData.addAll([
        MoreOptionsButton(
          onEdit: () {
            showDialog(
              context: context,
              builder: (context) =>
                  CategoryEditDialog(categoryWithCount.category!),
            );
          },
          onDelete: () {
            DialogUtils.showDeleteConfirmation(
              context,
              onConfirm: () => ref
                  .read(categoryServiceProvider.notifier)
                  .delete(categoryWithCount.category!),
            );
          },
        ),
      ]);
    } else {
      rowData.addAll([IconButton(onPressed: () {}, icon: Container())]);
    }
    return InkWell(
      onTap: () {
        ref
            .read(categoryStateProviderProvider.notifier)
            .changeCategory(categoryWithCount.category);
        context.pop();
      },
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.orangeAccent[100] : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowData,
          ),
        ),
      ),
    );
  }
}
