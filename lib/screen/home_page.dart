import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/domain/todo_with_category.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/screen/components/toolbar.dart';
import 'package:drift_todo_train/service/category_filter.dart';
import 'package:drift_todo_train/service/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    addTodo() async {
      await ref
          .read(todoServiceProvider.notifier)
          .saveTodo(description: _controller.text.trim());
      _controller.clear();
    }

    return DefaultLayout(
      title: 'Home',
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
              child: ref
                  .watch(getTodoWithCategoryProvider)
                  .when(
                    data: (List<TodoWithCategory> data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final TodoWithCategory todoWithCategory = data[index];
                          return ProviderScope(
                            overrides: [
                              currentTodoWithCategory.overrideWithValue(
                                todoWithCategory,
                              ),
                            ],
                            child: const TodoCard(),
                          );
                        },
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Text("error");
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

final currentTodoWithCategory = Provider<TodoWithCategory>(
  (ref) => throw UnimplementedError(),
);
