import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> get getDbFile async {
  final directory = await getApplicationDocumentsDirectory();
  final dbDir = Directory(p.join(directory.path, 'db'));
  if (!dbDir.existsSync()) {
    await dbDir.create(recursive: true);
  }

  final dbFilePath = p.join(directory.path, 'db/train8.db');

  return File(dbFilePath);
}
