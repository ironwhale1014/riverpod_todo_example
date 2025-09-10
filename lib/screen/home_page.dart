import 'package:drift_todo_train/common/ui/common_listview.dart';
import 'package:drift_todo_train/common/ui/layout.dart';
import 'package:drift_todo_train/domain/todo_model.dart';
import 'package:drift_todo_train/screen/component/card/todo_card.dart';
import 'package:drift_todo_train/screen/component/custom_drawer.dart';
import 'package:drift_todo_train/screen/component/dialog/add_todo.dart';
import 'package:drift_todo_train/service/category_state_provider.dart';
import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static String get routeName => 'HomePage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      drawer: CustomDrawer(),
      actions: [
        IconButton(
          onPressed: () {
            showAddTodoDialog(context);
          },
          icon: Icon(Icons.edit),
        ),
      ],
      title: ref.watch(categoryStateProvider)?.name ?? '기본',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CommonListview<TodoModel, BaseStateModel<TodoModel>>(
                provider: todoServiceProvider,
                itemBuilder: (context, index, model) => TodoCard(model),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
