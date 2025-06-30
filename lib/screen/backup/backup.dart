import 'dart:io';

import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/service/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class BackupButton extends ConsumerWidget {
  const BackupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () =>
          showDialog(context: context, builder: (_) => _BackupDialog()),
      icon: Icon(Icons.backup),
    );
  }
}

class _BackupDialog extends ConsumerWidget {
  const _BackupDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Backup'),
      actions: [
        TextButton(
          onPressed: () async {
            context.pop();
            final backupFile = await getBackupDbFile;
            if (backupFile.existsSync()) {
              backupFile.deleteSync();
            }
            ref.read(databaseProvider).customStatement('VACUUM INTO ?', [
              backupFile.path,
            ]);
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('back up end')));
            }
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () async {
            context.pop();
            final db = ref.read(databaseProvider);
            await db.close();

            final backupFile = await getBackupDbFile;
            if (!backupFile.existsSync()) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('back file not found')));
              }
              return;
            }

            final tempFile = File(
              p.join((await getTemporaryDirectory()).path, 'temp.db'),
            );
            final backUpDB = sqlite3.open(backupFile.path);
            backUpDB
              ..execute('VACUUM INTO?', [tempFile.path])
              ..dispose();
            tempFile.copySync((await getDbFile).path);
            tempFile.deleteSync();

            ref.invalidate(databaseProvider);
            ref.invalidate(getTodoWithCategoryProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('restore end')));
            }
          },
          child: Text('Restore'),
        ),
      ],
    );
  }
}
