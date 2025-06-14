import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:drift_todo_train/database/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/logger.dart';

class CategoriesDrawer extends ConsumerWidget {
  CategoriesDrawer({super.key});

  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Text(
              "Todo List with drift",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '폴더 추가',
                helperText: '폴더 추가는 여기에서',
              ),
              controller: categoryController,
              onFieldSubmitted: (_) {
                ref
                    .read(repositoryProvider.notifier)
                    .saveCategory(categoryController.text);
                categoryController.clear();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: ref
                  .watch(repositoryProvider.notifier)
                  .getCategoryWithCount(),
              builder:
                  (context, AsyncSnapshot<List<CategoryWithCount>> snapshot) {
                    if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          final category = categories[index];

                          return _CategoryDrawerEntry(category);
                        },
                      );
                    }
                    return Text("no Category");
                  },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDrawerEntry extends ConsumerWidget {
  _CategoryDrawerEntry(this.categoryWithCount);

  final CategoryWithCount categoryWithCount;

  final categoryEditController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Category? category = categoryWithCount.category;
    final isActive = ref.watch(categoryStateProvider)?.id == category?.id;

    if (category != null) {
      categoryEditController.text = category.name;
    }

    void updateCategoryName() {
      ref
          .read(repositoryProvider.notifier)
          .updateCategory(
            category!.copyWith(name: categoryEditController.text),
          );
      context.pop();
    }

    final List<Widget> rowData = [
      GestureDetector(
        onTap: () async {
          final Color? newColor = await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('pick color'),
              content: BlockPicker(
                pickerColor: category?.color ?? Colors.transparent,
                onColorChanged: (color) => context.pop(color),
              ),
            ),
          );
          if (newColor != null) {
            ref
                .read(repositoryProvider.notifier)
                .updateCategory(category!.copyWith(color: newColor));
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category?.color ?? Colors.transparent,
          ),
          child: SizedBox.square(dimension: 20),
        ),
      ),
      Expanded(
        child: Text(category?.name ?? "기본", overflow: TextOverflow.ellipsis),
      ),
      Text('${categoryWithCount.count} 개'),
    ];

    if (category != null) {
      rowData.addAll([
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('edit category name'),
                    content: TextFormField(
                      autofocus: true,
                      controller: categoryEditController,
                      decoration: InputDecoration(
                        helperText: 'edit your category name',
                        labelText: 'edit your category name',
                      ),
                      onFieldSubmitted: (_) => updateCategoryName(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text('cancel'),
                      ),
                      TextButton(
                        onPressed: updateCategoryName,
                        child: Text('save'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                final isConfirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('delete category??'),
                    content: Text("삭제된 카데고리의 할일은 기본으로 바뀝니다."),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(false),
                        child: Text('cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop(true);
                        },
                        child: Text('save'),
                      ),
                    ],
                  ),
                );
                if (isConfirm == true) {
                  ref
                      .read(repositoryProvider.notifier)
                      .deleteCategory(category);
                }
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: isActive
            ? Colors.orangeAccent.withValues(alpha: 255 * 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            ref.read(categoryStateProvider.notifier).setCategory(category);
            context.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 4,
              children: rowData,
            ),
          ),
        ),
      ),
    );
  }
}
