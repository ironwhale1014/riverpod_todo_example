import 'package:drift_todo_train/common/ui/common_listview.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/category_state_provider.dart';

class CustomDrawer extends HookConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = useTextEditingController();
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text('Category')),
          TextField(
            controller: categoryController,
            onSubmitted: (_) {
              ref
                  .read(categoryServiceProvider.notifier)
                  .saveCategory(categoryController.text.trim());
            },
          ),
          Expanded(
            child: CommonListview<Category, BaseStateModel<Category>>(
              provider: categoryServiceProvider,
              itemBuilder: (cotext, index, model) => InkWell(
                onTap: () {
                  ref.read(categoryStateProvider.notifier).setCategory(model);
                },
                child: ListTile(
                  title: Text(model.name ?? '기본'),
                  trailing: Text('${model.count} entities'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
