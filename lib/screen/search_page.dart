import 'package:drift_todo_train/common/logger.dart';
import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:drift_todo_train/screen/components/todo_card.dart';
import 'package:drift_todo_train/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<List<TodoWithCategory>>? searchResult;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        search();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() async {
    if (formKey.currentState!.validate()) {
      logger.d(controller.text);
      searchResult = ref
          .read(repositoryProvider.notifier)
          .searchTodoWithCategory('${controller.text}*');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Page")),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '검색할 내용을 입력해주세요'),
              controller: controller,
              validator: (_) {
                if (controller.text.isEmpty) {
                  return '입력 해주세요';
                }

                return null;
              },
            ),
            if (searchResult != null)
              Expanded(
                child: FutureBuilder(
                  future: searchResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<TodoWithCategory> todos = snapshot.data!;
                      return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) => ProviderScope(
                          overrides: [
                            currentTodo.overrideWithValue(todos[index]),
                          ],
                          child: TodoCard(),
                        ),
                      );
                    }

                    return CircularProgressIndicator();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
