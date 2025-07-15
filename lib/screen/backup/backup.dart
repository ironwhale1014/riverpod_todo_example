import 'dart:io';

import 'package:drift_todo_train/common/util/get_db_file.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:drift_todo_train/screen/components/custom_dialog.dart';
import 'package:drift_todo_train/service/category_filter.dart';
import 'package:drift_todo_train/service/todo_with_category_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class BackupButton extends ConsumerWidget {
  const BackupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => _BackupDialog(key: key),
        );
      },
      icon: Icon(Icons.backup),
    );
  }
}

class _BackupDialog extends ConsumerWidget {
  const _BackupDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog.withBtn(
      title: 'Backup your todo List',
      leftBtnText: 'restore',
      rightBtnText: 'save',
      leftBtnOnPressed: () async {
        final db = ref.read(databaseProvider);
        await db.close();

        final backupFile = await _getBackupFile;
        if (!backupFile.existsSync()) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('백업 파일이 없습니다.')));
          }
          return;
        }
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(p.join(tempDir.path, 'temp.db'));
        final backupDb = sqlite3.open(backupFile.path);
        backupDb
          ..execute('VACUUM INTO ?', [tempFile.path])
          ..dispose();
        tempFile.copySync((await getDbFile).path);
        tempFile.deleteSync();

        ref.invalidate(databaseProvider);
        ref.invalidate(todoWithCategoryStateProvider);

        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('복원 완료')));
          context.pop();
        }
      },
      rightBtnOnPressed: () async {
        final backupFile = await _getBackupFile;
        if (backupFile.existsSync()) {
          backupFile.deleteSync();
        }
        ref.read(databaseProvider).customStatement('VACUUM INTO ?', [
          backupFile.path,
        ]);
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('백업 완료')));
          context.pop();
        }
      },
    );
  }
}

Future<File> get _getBackupFile async {
  final directory = await getApplicationDocumentsDirectory();
  final backupDir = Directory(p.join(directory.path, 'backup'));
  if (!backupDir.existsSync()) {
    backupDir.createSync(recursive: true);
  }
  final backupFilePath = p.join(backupDir.path, 'backup.db');
  return File(backupFilePath);
}
