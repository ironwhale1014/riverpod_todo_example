import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/screen/components/custom_textfield.dart';
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
          ],
        ),
      ),
    );
  }
}
