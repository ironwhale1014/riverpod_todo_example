import 'package:drift_todo_train/common/layout/default_layout.dart';
import 'package:drift_todo_train/common/util/logger.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:drift_todo_train/model/todo_with_category.dart';
import 'package:drift_todo_train/provider/todo_with_catgory_provider.dart';
import 'package:drift_todo_train/screen/components/category_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'backup/backup.dart';
import 'components/todo_card.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addTodo() {
      if (controller.text.isNotEmpty) {
        final categoryId = ref.read(categoryStateProvider)?.id;
        ref
            .read(todoServiceProvider.notifier)
            .todoSave(
              description: controller.text.trim(),
              categoryId: categoryId,
            );
        controller.clear();
      }
    }

    return DefaultLayout(
      title: 'Home Page',
      drawer: CategoryDrawer(),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.pushNamed('search');
          },
        ),
        BackUpButton(),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              onFieldSubmitted: (_) => addTodo(),
            ),
            Expanded(
              child: ref
                  .watch(getTodoWithCategoryProvider)
                  .when(
                    data: (List<TodoWithCategory> todoWithCategories) {
                      logger.d(todoWithCategories.length);
                      return ListView.builder(
                        itemCount: todoWithCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProviderScope(
                            overrides: [
                              currentTodo.overrideWithValue(
                                todoWithCategories[index],
                              ),
                            ],
                            child: const TodoCard(),
                          );
                        },
                      );
                    },
                    error: (e, _) => Text(e.toString()),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

final currentTodo = Provider<TodoWithCategory>(
  (ref) => throw UnimplementedError(),
);
