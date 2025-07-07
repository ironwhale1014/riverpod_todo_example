import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDialog extends ConsumerWidget {
  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.leftBtnOnPressed,
    this.rightBtnOnPressed,
  });

  final String? title;
  final Widget? content;
  final VoidCallback? leftBtnOnPressed;
  final VoidCallback? rightBtnOnPressed;

  factory CustomDialog.withBtn({
    String? title,
    Widget? content,
    required VoidCallback leftBtnOnPressed,
    required VoidCallback rightBtnOnPressed,
  }) => CustomDialog(
    title: title,
    content: content,
    rightBtnOnPressed: rightBtnOnPressed,
    leftBtnOnPressed: leftBtnOnPressed,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content,
      actions: [
        TextButton(onPressed: leftBtnOnPressed, child: Text('Cancel')),
        TextButton(onPressed: rightBtnOnPressed, child: Text('Ok')),
      ],
    );
  }
}
