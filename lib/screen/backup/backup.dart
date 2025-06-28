import 'dart:io';

import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/database/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../common/util/logger.dart';

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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('back up todos'),
      actions: [
        TextButton(
          onPressed: () => _createBackup(context, ref),
          child: Text('save'),
        ),
        TextButton(
          onPressed: () => _restore(context, ref),
          child: Text('restore'),
        ),
      ],
    );
  }

  _restore(BuildContext context, WidgetRef ref) async {
    context.pop();
    final folder = await getApplicationDocumentsDirectory();
    final backupFolder = Directory(p.join(folder.path, 'backup'));
    final backUpFile = File(p.join(backupFolder.path, 'backup2.db'));

    if (!backupFolder.existsSync()) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('not found backup DB')));
      }
      return;
    }
    final tempDbFolderPath = (await getTemporaryDirectory()).path;
    final tempDbFile = File(p.join(tempDbFolderPath, 'tempDb.db'));

    final backDb = sqlite3.open(backUpFile.path);

    backDb
      ..execute('VACUUM INTO ?', [tempDbFile.path])
      ..dispose();
    await tempDbFile.copy((await getDbFile).path);
    tempDbFile.deleteSync();
    //
    ref.invalidate(appDatabaseProvider);
    ref.invalidate(todoServiceProvider);
    logger.d("dd");
  }

  _createBackup(BuildContext context, WidgetRef ref) async {
    context.pop();
    final folder = await getApplicationDocumentsDirectory();
    final backupFolder = Directory(p.join(folder.path, 'backup'));
    if (!backupFolder.existsSync()) {
      backupFolder.createSync(recursive: true);
    }
    final backUpFile = File(p.join(backupFolder.path, 'backup2.db'));

    if (backUpFile.existsSync()) {
      backUpFile.deleteSync();
    }

    ref.read(appDatabaseProvider).customStatement('VACUUM INTO ? ', [
      backUpFile.path,
    ]);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('back up success')));
    }
  }
}
