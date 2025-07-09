import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDialog extends ConsumerWidget {
  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.leftBtnOnPressed,
    this.rightBtnOnPressed,
    this.leftBtnText = 'Cancel',
    this.rightBtnText = 'Ok',
  });

  final String? title;
  final Widget? content;
  final VoidCallback? leftBtnOnPressed;
  final VoidCallback? rightBtnOnPressed;
  final String leftBtnText;
  final String rightBtnText;

  factory CustomDialog.withBtn({
    String? title,
    Widget? content,
    required VoidCallback leftBtnOnPressed,
    required VoidCallback rightBtnOnPressed,
    String leftBtnText = 'Cancel',
    String rightBtnText = 'Ok',
  }) => CustomDialog(
    title: title,
    content: content,
    rightBtnOnPressed: rightBtnOnPressed,
    leftBtnOnPressed: leftBtnOnPressed,
    leftBtnText: leftBtnText,
    rightBtnText: rightBtnText,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: title != null ? Text(title!, textAlign: TextAlign.center) : null,
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: 8),
      actions: [
        if (leftBtnOnPressed != null)
          MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: leftBtnOnPressed,
            child: Text(leftBtnText),
          ),
        if (rightBtnOnPressed != null)
          MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: rightBtnOnPressed,
            child: Text(rightBtnText),
          ),
      ],
    );
  }
}
