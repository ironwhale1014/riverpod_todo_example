import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/util/logger.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<List<TodoWithCategory>>? searchResults;

  void listener() async {
    logger.d(controller.text);
    if (formKey.currentState!.validate()) {
      setState(() {
        searchResults = ref
            .read(todoServiceProvider.notifier)
            .search(controller.text.trim());
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
              child: FutureBuilder(
                future: searchResults,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<TodoWithCategory>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        final List<TodoWithCategory> todoWithCategories =
                            snapshot.data!;

                        return ListView.builder(
                          itemCount: todoWithCategories.length,
                          itemBuilder: (context, index) {
                            return TodoCard(
                              todoWithCategory: todoWithCategories[index],
                            );
                          },
                        );
                      }
                      return Center(child: Text('검색어를 입력해주세요'));
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
