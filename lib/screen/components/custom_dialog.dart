import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDialog extends ConsumerWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.content,
    required this.onLeftBtnClick,
    required this.onRightBtnClick,
  });

  final String title;
  final Widget? content;
  final VoidCallback onLeftBtnClick;
  final VoidCallback onRightBtnClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        TextButton(onPressed: onLeftBtnClick, child: const Text('Cancel')),
        TextButton(onPressed: onRightBtnClick, child: const Text('OK')),
      ],
    );
  }
}
