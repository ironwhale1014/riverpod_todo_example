import 'package:drift_todo_train/database/category_service.dart';
import 'package:drift_todo_train/model/category_with_count.dart';
import 'package:drift_todo_train/provider/todo_with_catgory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryDrawer extends ConsumerWidget {
  CategoryDrawer({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DrawerHeader(child: Text('Todo')),
            TextFormField(
              controller: controller,
              onFieldSubmitted: (_) {
                if (controller.text.isNotEmpty) {
                  ref
                      .read(categoryServiceProvider.notifier)
                      .saveCategory(controller.text.trim());
                  controller.clear();
                }
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: ref
                    .watch(categoryServiceProvider.notifier)
                    .getCategoriesWithCount(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final categoryWithCount = snapshot.data!;
                    return ListView.builder(
                      itemCount: categoryWithCount.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _CategoryDrawerEntry(categoryWithCount[index]);
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDrawerEntry extends ConsumerWidget {
  _CategoryDrawerEntry(this.categoryWithCount);

  final CategoryWithCount categoryWithCount;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive =
        ref.watch(categoryStateProvider)?.id == categoryWithCount.category?.id;

    if (categoryWithCount.category != null) {
      controller.text = categoryWithCount.category!.name;
    }
    final List<Widget> rowData = [
      _buildColorPicker(context, ref),
      _buildCategoryWithCount(),
    ];

    if (categoryWithCount.category != null) {
      rowData.addAll([
        IconButton(
          color: Colors.red,
          onPressed: () {
            ref
                .read(categoryServiceProvider.notifier)
                .deleteCategory(categoryWithCount.category!);
          },
          icon: Icon(Icons.delete),
        ),
        IconButton(
          color: Colors.black,
          onPressed: () async {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("edit category"),
                content: TextFormField(controller: controller),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty &&
                          categoryWithCount.category != null) {
                        ref
                            .read(categoryServiceProvider.notifier)
                            .updateCategory(
                              categoryWithCount.category!.copyWith(
                                name: controller.text.trim(),
                              ),
                            );
                        context.pop();
                      }
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.edit),
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: isActive ? Colors.grey[200] : Colors.transparent,
        child: InkWell(
          onTap: () {
            ref
                .read(categoryStateProvider.notifier)
                .setCategory(categoryWithCount.category);
            context.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowData,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildCategoryWithCount() {
    return Expanded(
      child: Column(
        spacing: 12,
        children: [
          Text(categoryWithCount.category?.name ?? '기본'),
          Text('${categoryWithCount.count.toString()} entries'),
        ],
      ),
    );
  }

  GestureDetector _buildColorPicker(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final Color? selectedColor = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("pick color"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: categoryWithCount.category?.color,
                onColorChanged: (Color value) => context.pop(value),
              ),
            ),
          ),
        );
        if (selectedColor != null) {
          ref
              .read(categoryServiceProvider.notifier)
              .updateCategory(
                categoryWithCount.category!.copyWith(color: selectedColor),
              );
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              categoryWithCount.category?.color ??
              Color.fromARGB(255, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: SizedBox.square(dimension: 20),
      ),
    );
  }
}
