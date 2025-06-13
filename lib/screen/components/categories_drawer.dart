import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:drift_todo_train/database/state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                hintText: '폴더 추가'
                    ,helperText: '폴더 추가는 여기에서'
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
  const _CategoryDrawerEntry(this.categoryWithCount);

  final CategoryWithCount categoryWithCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Category? category = categoryWithCount.category;
    final isActive = ref.watch(categoryStateProvider)?.id == category?.id;
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
            child: Text(category?.name ?? "기본"),
          ),
        ),
      ),
    );
  }
}
