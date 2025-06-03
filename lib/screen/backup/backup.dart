import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_todo_train/database/connection/native.dart';
import 'package:drift_todo_train/database/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

class BackUpIcon extends StatelessWidget {
  const BackUpIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const BackupDialog(),
      ),
      icon: const Icon(Icons.save),
    );
  }
}

class BackupDialog extends ConsumerWidget {
  const BackupDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Database backup'),
      content: const Text(
        'Here, you can save the database to a file or restore a created '
        'backup.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            createDatabaseBackup(ref.read(appDatabaseStateProvider), context);
          },
          child: const Text('Save'),
        ),

        TextButton(
          onPressed: () async {
            final db = ref.read(appDatabaseStateProvider);
            await db.close(); // 왜 닫지??

            final backupFile = await FilePicker.platform.pickFiles();
            if (backupFile == null) return;
            final backUpDb = sqlite3.open(backupFile.files.single.path!);

            final tempPath = await getTemporaryDirectory();
            final tempDb = p.join(tempPath.path, 'import.db');
            backUpDb
              ..execute('VACUUM INTO ?', [tempDb])
              ..dispose();

            final tempDbFile = File(tempDb);
            await tempDbFile.copy((await databaseFile).path);
            await tempDbFile.delete();

            ref.read(appDatabaseStateProvider.notifier).resetDatabase();
          },
          child: const Text('Restore'),
        ),
      ],
    );
  }
}

Future<void> createDatabaseBackup(
  DatabaseConnectionUser database,
  BuildContext context,
) async {

  await Permission.manageExternalStorage.request();

  if (await Permission.storage.request().isGranted ||
      (await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted)) {
    final choosenDirectory = await FilePicker.platform.getDirectoryPath();
    if (choosenDirectory == null) return;

    final parent = Directory(choosenDirectory);
    final file = File(p.join(choosenDirectory, 'drift_example_backup.db'));

    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }

    if (await file.exists()) {
      await file.delete();
    }

    await database.customStatement('VACUUM INTO ?', [file.absolute.path]);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 저장을 위해 저장소 접근 권한이 필요합니다.')),
      );
    }
  }
}
