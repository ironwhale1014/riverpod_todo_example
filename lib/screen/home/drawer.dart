import 'package:drift/drift.dart' hide Column;
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/screen/home/state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoriesDrawer extends ConsumerWidget {
  const CategoriesDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            child: Text(
              'Todo-List Demo with drift',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
          Flexible(
            child: StreamBuilder<List<CategoryWithCount>>(
              stream: ref.watch(appDatabaseStateProvider).categoriesWithCount(),
              builder: (context, snapshot) {
                final categories = snapshot.data ?? <CategoryWithCount>[];
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _CategoryDrawerEntry(entry: categories[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDrawerEntry extends ConsumerWidget {
  const _CategoryDrawerEntry({super.key, required this.entry});

  final CategoryWithCount entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = entry.category;
    final isActive = ref.watch(activeCategory)?.id == category?.id;

    String title;
    if (category == null) {
      title = 'No category';
    } else {
      title = category.name;
    }

    final rowContent = [
      if (category != null)
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () async {
              final newColor = await _selectColor(context, category.color);
              if (newColor != null) {
                final update = ref.read(appDatabaseStateProvider).categories.update()
                  ..whereSamePrimaryKey(category);
                await update.write(CategoriesCompanion(color: Value(newColor)));
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: category.color,
              ),
              child: const SizedBox.square(dimension: 20),
            ),
          ),
        ),
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive
              ? Theme.of(context).colorScheme.secondary
              : Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text('${entry.count} entries'),
      ),
    ];

    if (category != null) {
      rowContent.addAll([
        Spacer(),
        IconButton(
          color: Colors.red,
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete'),
                  content: Text('Really delete category $title?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );

            if (confirmed == true) {
              ref.read(appDatabaseStateProvider).deleteCategory(category);
            }
          },
          icon: Icon(Icons.delete_outline),
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
            ref.read(activeCategory.notifier).state = category;
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: rowContent),
          ),
        ),
      ),
    );
  }
}

Future<Color?> _selectColor(BuildContext context, Color initial) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: initial,
            onColorChanged: (color) => Navigator.pop(context, color),
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
      );
    },
  );
}
