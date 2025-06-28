import 'dart:io';

import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'package:drift_todo_train/provider/todo_with_catgory_provider.dart';

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
        TextButton(
          onPressed: () async {
            final directory = await getApplicationDocumentsDirectory();
            final backupDirectory = Directory(p.join(directory.path, 'backup'));
            final backUpFile = File(
              p.join(backupDirectory.path, 'todo_backup.db'),
            );

            if (!backUpFile.existsSync()) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('백업 파일 없음')));
              }
              return;
            }

            final tempDir = await getTemporaryDirectory();
            final tempDbPath = p.join(tempDir.path, 'temp.db');
            final backUpDb = sqlite3.open(backUpFile.path);
            backUpDb
              ..execute('VACUUM INTO ?', [tempDbPath])
              ..dispose();

            final tempDbFile = File(tempDbPath);
            final mainDbFile = await getDbFile;
            await tempDbFile.copy(mainDbFile.path);
            await tempDbFile.delete();

            // Invalidate the database provider to force a new connection
            ref.invalidate(databaseStateProvider);
            // Invalidate the todo service provider to ensure it uses the new database instance
            ref.invalidate(todoServiceProvider);
            // Invalidate the todo list provider to refresh the UI
            ref.invalidate(getTodoWithCategoryProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('복원이 완료되었습니다.')));
            }
          },
          child: Text('restore'),
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
          'todo_backup.db',
          // 'todo_backup_${DateTime.now().toString()}.db',
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
