import 'package:drift_todo_train/common/components/common_listview.dart';
import 'package:drift_todo_train/common/components/custom_dialog.dart';
import 'package:drift_todo_train/common/components/custom_textfield.dart';
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
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () async {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final offset = renderBox.localToGlobal(Offset.zero);

                final selectedValue = await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx + renderBox.size.width,
                    offset.dy,
                    offset.dx + renderBox.size.width,
                    offset.dy,
                  ),
                  items: [
                    PopupMenuItem(value: 'edit', child: Text('수정하기')),
                    PopupMenuItem(value: 'delete', child: Text('삭제하기')),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );

                if (selectedValue != null) {
                  switch (selectedValue) {
                    case 'edit':
                      showDialog(
                        context: context,
                        builder: (context) =>
                            CategoryEditDialog(categoryWithCount.category!),
                      );
                    case 'delete':
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            titleText: 'delete it?',
                            btnLeftText: 'Cancel',
                            btnRightText: 'Ok',
                            btnLeftFunc: () {
                              context.pop();
                            },
                            btnRightFunc: () async {
                              await ref
                                  .read(categoryServiceProvider.notifier)
                                  .delete(categoryWithCount.category!);
                              context.pop();
                            },
                          );
                        },
                      );
                  }
                }
              },
              icon: Icon(Icons.more_vert),
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
