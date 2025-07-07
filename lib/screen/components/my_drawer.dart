import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/screen/components/category_card.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final categories = ref
        .watch(categoryServiceProvider.notifier)
        .getCategories();

    void addCategory() async {
      await ref
          .read(categoryServiceProvider.notifier)
          .saveCategory(name: controller.text.trim());
    }

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text("Todo")),
          CustomTextFormField(
            controller: controller,
            onFieldSubmitted: (_) => addCategory(),
            hintText: 'input category',
          ),
          Expanded(
            child: StreamBuilder(
              stream: categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final categories = snapshot.data;
                  return ListView.builder(
                    itemCount: categories!.length,
                    itemBuilder: (context, index) {
                      final categoryWithCount = categories[index];

                      return InkWell(
                        onTap: () {
                          ref
                              .read(categoryStateProvider.notifier)
                              .changeCategory(categoryWithCount.category);
                          context.pop();
                        },
                        child: CategoryCard(categoryWithCount),
                      );
                    },
                  );
                }
                return Text('no category');
              },
            ),
          ),
        ],
      ),
    );
  }
}
