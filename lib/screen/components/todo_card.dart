import 'package:drift_todo_train/common/date_format.dart';
import 'package:drift_todo_train/database/repository_provider.dart';
import 'package:drift_todo_train/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'edit_dialog.dart';

class TodoCard extends HookConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodo);

    final editController = useTextEditingController();
    final tileFocus = useFocusNode();
    final textFieldFocus = useFocusNode();
    final isFocused = useIsFocused(tileFocus);
    return Focus(
      focusNode: tileFocus,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          editController.text = todo.todoEntry.description;
        } else {
          ref
              .read(repositoryProvider.notifier)
              .updateTodos(
                todo: todo.todoEntry.copyWith(description: editController.text),
              );
        }
      },
      child: ListTile(
        onTap: () {
          tileFocus.requestFocus();
          textFieldFocus.requestFocus();
        },
        subtitle: Text(
          todo.todoEntry.dueDate == null
              ? 'not set due date'
              : dateFormat.format(todo.todoEntry.dueDate!).toString(),
        ),
        title: (isFocused)
            ? TextField(
                controller: editController,
                focusNode: textFieldFocus,
                autofocus: true,
              )
            : Text(todo.todoEntry.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.grey,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => EditDialog(todoEntry: todo.todoEntry),
                );
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              color: Colors.red,
              onPressed: () {
                ref
                    .read(repositoryProvider.notifier)
                    .deleteTodos(todo: todo.todoEntry);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

bool useIsFocused(FocusNode value) {
  final isFocused = useState(value.hasFocus);
  useEffect(() {
    void listener() {
      isFocused.value = value.hasFocus;
    }

    value.addListener(listener);
    return () => value.removeListener(listener);
  }, [value]);

  return isFocused.value;
}
