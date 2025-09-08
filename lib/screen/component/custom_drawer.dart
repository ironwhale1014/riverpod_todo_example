import 'package:drift_todo_train/common/ui/common_listview.dart';
import 'package:drift_todo_train/common/ui/component/custom_text_form_field.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/screen/component/category_card.dart';
import 'package:drift_todo_train/screen/component/edit_category.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/category_state_provider.dart';
import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDrawer extends HookConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = useTextEditingController();
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text('Category')),
          _InputCategory(categoryController: categoryController),
          _CategoryListView(),
        ],
      ),
    );
  }
}

class _CategoryListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: CommonListview<Category, BaseStateModel<Category>>(
        provider: categoryServiceProvider,
        itemBuilder: (cotext, index, model) => InkWell(
          onTap: () {
            ref.read(categoryStateProvider.notifier).setCategory(model);
            // 카드를 탭했을 때의 기본 동작 (예: 해당 카테고리 상세 페이지로 이동)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("'${model.name}' 카테고리를 선택했습니다."),
                duration: const Duration(seconds: 1),
              ),
            );
            cotext.pop();
          },
          child: CategoryCard(
            category: model,
            onEdit: () {
              showEditCategory(cotext, model);
            },
            onDelete: () {
              ref.read(categoryServiceProvider.notifier).deleteCategory(model);
            },
          ),
        ),
      ),
    );
  }
}

class _InputCategory extends HookConsumerWidget {
  const _InputCategory({super.key, required this.categoryController});

  final TextEditingController categoryController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomTextFormField(
        controller: categoryController,
        hintText: 'write category',
        onFieldSubmitted: (_) {
          ref
              .read(categoryServiceProvider.notifier)
              .saveCategory(categoryController.text.trim());
        },
      ),
    );
  }
}
