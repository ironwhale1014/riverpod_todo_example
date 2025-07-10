import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/service/todo_list_filter_state_provider.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:drift_todo_train/service/todo_with_category_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/util/logger.dart';
import '../domain/base_model.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void listener() async {
    if (formKey.currentState!.validate()) {
      ref
          .read(todoWithCategoryStateProvider.notifier)
          .search(controller.text.trim());
    } else {
      setState(() {
        ref.read(todoWithCategoryStateProvider.notifier).paginate();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoWithCategoryStateProvider);
    return DefaultLayout(
      title: 'search',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextFormField(
              controller: controller,
              validator: (_) {
                if (controller.text.trim().length < 2) {
                  return '2글자 이상 입력해주세요';
                }
                return null;
              },
            ),
            Expanded(
              child: switch (state) {
                Loading() => const Center(child: CircularProgressIndicator()),
                Model<TodoWithCategory>() => ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) =>
                      TodoCard(todoWithCategory: state.data[index]),
                ), // 혹시 모를 예외 처리
              },
            ),
          ],
        ),
      ),
    );
  }
}
