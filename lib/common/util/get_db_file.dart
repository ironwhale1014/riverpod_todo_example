import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'logger.dart';

Future<File> get getDbFile async {
  final dir = await getApplicationDocumentsDirectory();
  final dbFilePath = p.join(dir.path, 'train7.db');
  return File(dbFilePath);
}

Future<File> get getBackupDbFile async {
  final dir = await getApplicationDocumentsDirectory();
  final backUpDir = Directory(p.join(dir.path, 'backup'));
  if (!backUpDir.existsSync()) {
    backUpDir.createSync(recursive: true);
    logger.d('2');
  }
  logger.d('3');

  return File(p.join(backUpDir.path, 'backup.db'));
}
