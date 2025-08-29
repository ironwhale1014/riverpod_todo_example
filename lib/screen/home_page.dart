import 'package:drift_todo_train/common/ui/common_listview.dart';
import 'package:drift_todo_train/common/ui/layout.dart';
import 'package:drift_todo_train/domain/category.dart';
import 'package:drift_todo_train/service/category_service.dart';
import 'package:drift_todo_train/service/state_model/base_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static String get routeName => 'HomePage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: 'category',
      child: CommonListview<Category, BaseStateModel<Category>>(
        provider: categoryServiceProvider,
        itemBuilder: (context, index, model) =>
            ListTile(leading: Text(model.name ?? '기본')),
      ),
    );
  }
}
