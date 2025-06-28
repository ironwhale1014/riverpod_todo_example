import 'dart:io';

import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/provider/todo_with_catgory_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

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

  _createBackup(BuildContext context, WidgetRef ref) async {
    context.pop();
    final backUpFile = await _getBackupFile;
    if (backUpFile.existsSync()) {
      backUpFile.deleteSync();
    }
    ref.read(appDatabaseProvider).customStatement('VACUUM INTO ?', [
      backUpFile.path,
    ]);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("backUp end")));
    }
  }

  _restore(BuildContext context, WidgetRef ref) async {
    context.pop();
    final db = ref.read(appDatabaseProvider);
    await db.close();
    final backUpFile = await _getBackupFile;
    if (!backUpFile.existsSync()) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("backUp file not found")));
      }
      return;
    }
    final tempFile = File(
      p.join((await getTemporaryDirectory()).path, 'temp.db'),
    );
    final backupDb = sqlite3.open(backUpFile.path);
    backupDb
      ..execute('VACUUM INTO ?', [tempFile.path])
      ..dispose();

    final dbFile = await getDbFile;
    tempFile.copySync(dbFile.path);
    tempFile.deleteSync();

    ref.invalidate(appDatabaseProvider);
    ref.invalidate(getTodoWithCategoryProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("backUp end")));
    }
  }

  Future<File> get _getBackupFile async {
    final dir = await getApplicationDocumentsDirectory();
    final backUpFolder = Directory(p.join(dir.path, 'backup'));
    if (!backUpFolder.existsSync()) {
      backUpFolder.createSync(recursive: true);
    }

    return File(p.join(backUpFolder.path, 'backup3.db'));
  }
}
