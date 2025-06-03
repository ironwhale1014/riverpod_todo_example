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
            await db.close(); // 기존 DB 닫기

            // 앱 내부 백업 파일 경로
            final backupDir = await getExternalStorageDirectory(); //
            print(backupDir); // 또는 getApplicationDocumentsDirectory()
            final backupFile = File(
              p.join(backupDir!.path, 'drift_example_backup.db'),
            );

            if (!await backupFile.exists()) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('복원할 백업 파일이 없습니다.')),
                );
              }
              return;
            }

            // 백업 파일을 임시 DB로 열기
            final tempPath = await getTemporaryDirectory();
            final tempDbPath = p.join(tempPath.path, 'temp_import.db');

            final backUpDb = sqlite3.open(backupFile.path);
            backUpDb
              ..execute('VACUUM INTO ?', [tempDbPath])
              ..dispose();

            // 기존 DB 덮어쓰기
            final tempDbFile = File(tempDbPath);
            final mainDbFile = await databaseFile; // 기존 DB 파일 경로
            await tempDbFile.copy(mainDbFile.path);
            await tempDbFile.delete();

            // DB 다시 열기
            ref.read(appDatabaseStateProvider.notifier).resetDatabase();

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('복원이 완료되었습니다.')));
            }
          },
          child: const Text('Restore'),
        ),
      ],
    );
  }
}

// Future<void> createDatabaseBackup(
//   DatabaseConnectionUser database,
//   BuildContext context,
// ) async {
//
//   if (await Permission.storage.request().isGranted ||
//       await Permission.manageExternalStorage.request().isGranted) {
//     final choosenDirectory = await FilePicker.platform.getDirectoryPath();
//     if (choosenDirectory == null) return;
//
//     final parent = Directory(choosenDirectory);
//     final file = File(p.join(choosenDirectory, 'drift_example_backup.db'));
//
//     if (!await parent.exists()) {
//       await parent.create(recursive: true);
//     }
//
//     if (await file.exists()) {
//       await file.delete();
//     }
//
//     await database.customStatement('VACUUM INTO ?', [file.absolute.path]);
//   } else {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('파일 저장을 위해 저장소 접근 권한이 필요합니다.')),
//       );
//     }
//   }
// }
Future<void> createDatabaseBackup(
  DatabaseConnectionUser database,
  BuildContext context,
) async {
  try {
    // 앱 전용 저장소 경로 가져오기
    final directory =
        await getExternalStorageDirectory(); // 또는 getApplicationDocumentsDirectory()
    if (directory == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('백업 디렉토리를 찾을 수 없습니다.')));
      }
      return;
    }

    final backupFile = File(p.join(directory.path, 'drift_example_backup.db'));

    // 기존 파일이 있으면 삭제
    if (await backupFile.exists()) {
      await backupFile.delete();
    }

    // 백업 수행
    await database.customStatement('VACUUM INTO ?', [backupFile.path]);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('백업 완료: ${backupFile.path}')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('백업 중 오류 발생: $e')));
    }
  }
}
