import 'package:drift_todo_train/domain/category_with_count.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryDrawer extends ConsumerWidget {
  CategoryDrawer({super.key});

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryWithCount = ref
        .watch(categoryServiceProvider.notifier)
        .getCategoryWithCount();
    return Drawer(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            DrawerHeader(child: Text("카테고리")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: '카테고리 입력'),
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'input category name';
                  }

                  if (value == '기본') {
                    return '기본 카테고리는 사용 불가';
                  }

                  return null;
                },
                onFieldSubmitted: (_) => _addCategory(ref),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: categoryWithCount,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final categories = snapshot.data!;
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryDrawerEntry(
                          categoryWithCount: categories[index],
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCategory(WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      await ref
          .read(categoryServiceProvider.notifier)
          .saveCategory(name: controller.text.trim());
      controller.clear();
    }
  }
}

class CategoryDrawerEntry extends ConsumerWidget {
  const CategoryDrawerEntry({super.key, required this.categoryWithCount});

  final CategoryWithCount categoryWithCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isActive =
        ref.watch(categoryServiceProvider)?.id ==
        categoryWithCount.category?.id;

    final List<Widget> rowData = [
      ColorCircle(color: categoryWithCount.category?.color),
      SizedBox(width: 16),
      Expanded(
        child: Text(
          categoryWithCount.category?.name ?? '기본',
          style: TextStyle(fontSize: 16),
        ),
      ),
      Text('${categoryWithCount.count} 개'),
    ];

    if (categoryWithCount.category != null) {
      rowData.addAll([
        Row(
          children: [
            IconButton(
              color: Colors.red,
              onPressed: () async {
                await ref
                    .read(categoryServiceProvider.notifier)
                    .deleteCategory(category: categoryWithCount.category!);
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              color: Colors.black,
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) =>
                      CategoryEditDialog(categoryWithCount: categoryWithCount),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ]);
    }

    return Material(
      color: isActive ? Colors.orangeAccent[100] : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            ref
                .read(categoryServiceProvider.notifier)
                .changeCategory(categoryWithCount.category);
            context.pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowData,
          ),
        ),
      ),
    );
  }
}

class CategoryEditDialog extends ConsumerStatefulWidget {
  const CategoryEditDialog({super.key, required this.categoryWithCount});

  final CategoryWithCount categoryWithCount;

  @override
  ConsumerState createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends ConsumerState<CategoryEditDialog> {
  final TextEditingController controller = TextEditingController();
  late final CategoryWithCount categoryWithCount;

  late Color selectedColor;

  @override
  void initState() {
    categoryWithCount = widget.categoryWithCount;
    controller.text = categoryWithCount.category!.name;
    selectedColor = categoryWithCount.category!.color;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('카테고리 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(controller: controller, autofocus: true),
          SizedBox(height: 16),
          Row(
            children: [
              Text('카테고리 색'),
              Spacer(),
              InkWell(
                onTap: _pickColor,
                child: ColorCircle(color: selectedColor),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: Text('취소')),
        TextButton(onPressed: _updateCategory, child: Text('저장')),
      ],
    );
  }

  _pickColor() async {
    final pickColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: BlockPicker(
            pickerColor: categoryWithCount.category!.color,
            onColorChanged: (color) => context.pop(color),
          ),
        );
      },
    );

    if (pickColor != null) {
      setState(() {
        selectedColor = pickColor;
      });
    }
  }

  _updateCategory() async {
    context.pop();
    await ref
        .read(categoryServiceProvider.notifier)
        .updateCategory(
          category: categoryWithCount.category!.copyWith(
            name: controller.text.trim(),
            color: selectedColor,
          ),
        );
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({super.key, required this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.white,
      ),
      child: SizedBox.square(dimension: 20),
    );
  }
}
