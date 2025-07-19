import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.titleText,
    this.child,
    this.btnLeftFunc,
    this.btnRightFunc,
    this.btnLeftText = 'Cancel',
    this.btnRightText = 'OK',
  });

  final String titleText;
  final Widget? child;
  final VoidCallback? btnLeftFunc;
  final VoidCallback? btnRightFunc;
  final String btnLeftText;
  final String btnRightText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titleText,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
      content: child,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed:
              btnLeftFunc ??
              () {
                context.pop();
              },
          child: Text(btnLeftText),
        ),
        TextButton(onPressed: btnRightFunc, child: Text(btnRightText)),
      ],
    );
  }
}
