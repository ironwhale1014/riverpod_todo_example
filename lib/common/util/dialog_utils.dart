import 'package:drift_todo_train/common/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogUtils {
  static void showDeleteConfirmation(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          titleText: 'delete it?',
          btnLeftText: 'Cancel',
          btnRightText: 'Ok',
          btnLeftFunc: () {
            context.pop();
          },
          btnRightFunc: () async {
            await onConfirm();
            if (context.mounted) {
              context.pop();
            }
          },
        );
      },
    );
  }
}
