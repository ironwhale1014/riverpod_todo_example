import 'dart:io';

import 'package:drift_todo_train/database/database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BackUpButton extends ConsumerWidget {
  const BackUpButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () =>
          showDialog(context: context, builder: (context) => _BackUpDialog()),
      icon: Icon(Icons.backup),
    );
  }
}

class _BackUpDialog extends ConsumerWidget {
  const _BackUpDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('database backup'),
      actions: [
        TextButton(
          onPressed: () => _createBackupFile(context, ref),
          child: Text('save'),
        ),
      ],
    );
  }

  _createBackupFile(BuildContext context, WidgetRef ref) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupDirectory = Directory(p.join(directory.path, 'backup'));
      if (!backupDirectory.existsSync()) {
        backupDirectory.createSync(recursive: true);
      }

      final backupFile = File(
        p.join(
          backupDirectory.path,
          'todo_backup_${DateTime.now().toString()}.db',
        ),
      );
      if (backupFile.existsSync()) {
        backupFile.deleteSync();
      }
      await ref.read(databaseStateProvider).customStatement('VACUUM INTO ?', [
        backupFile.path,
      ]);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('백업 완료')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
