import 'package:drift_todo_train/common/date_format.dart';
import 'package:drift_todo_train/screen/home_page.dart';
import 'package:drift_todo_train/service/service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



class TodoCard extends ConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodo);
     String dueDate = 'not set due Date';
    if(todo.dueDate !=null){
      dueDate = dateFormat.format(todo.dueDate!).toString();
    }
    return Card(
      color: Colors.brown[100],
      child: ListTile(
        title: Text(todo.description),
        subtitle: Text(dueDate),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton(
              onPressed: () {
                ref.read(todoServiceProvider.notifier).deleteTodo(todo: todo);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
