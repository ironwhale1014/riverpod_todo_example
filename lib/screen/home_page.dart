import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/domain/base_model.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/backup/backup.dart';
import 'package:drift_todo_train/screen/components/common_listview.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/screen/components/my_drawer.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/screen/components/toolbar.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/todo_with_category_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoWithCategoryStateProvider);
    addTodo() async {
      await ref
          .read(todoWithCategoryStateProvider.notifier)
          .save(
            description: _controller.text.trim(),
            categoryId: ref.read(categoryStateProvider)?.id,
          );
      _controller.clear();
    }

    return DefaultLayout(
      drawer: MyDrawer(),
      title: ref.watch(categoryStateProvider)?.name ?? '기본',
      actions: [
        IconButton(
          onPressed: () {
            context.pushNamed('search');
          },
          icon: Icon(Icons.search),
        ),
        BackupButton(),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              controller: _controller,
              hintText: 'input todo',
              validator: (_) {
                if (_controller.text.trim().isEmpty) {
                  return '입력 해주세요';
                }

                return null;
              },
              onFieldSubmitted: (_) => addTodo(),
            ),
            SizedBox(height: 16),
            Toolbar(),
            Expanded(
              child: CommonListview<BaseModel, Model<TodoWithCategory>>(
                provider: todoWithCategoryStateProvider,
                itemBuilder: (context, index, model) {
                  return TodoCard(todoWithCategory: model.data[index]);
                },
              ),
            ),
            // Expanded(
            //   child: ref
            //       .watch(getTodoWithCategoryProvider)
            //       .when(
            //         data: (List<TodoWithCategory> data) {
            //           return ListView.builder(
            //             itemCount: data.length,
            //             itemBuilder: (context, index) {
            //               final TodoWithCategory todoWithCategory = data[index];
            //               return TodoCard(todoWithCategory: todoWithCategory);
            //             },
            //           );
            //         },
            //         error: (Object error, StackTrace stackTrace) {
            //           return Text("error");
            //         },
            //         loading: () {
            //           return Center(child: CircularProgressIndicator());
            //         },
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}

final currentTodoWithCategory = Provider<TodoWithCategory>(
  (ref) => throw UnimplementedError(),
);
