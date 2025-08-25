import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> getDbFile() async {
  final baseDirectory = await getApplicationDocumentsDirectory();
  final String dbDirectoryName = 'db';
  final String dbDirectoryPath = p.join(baseDirectory.path, dbDirectoryName);
  final dbDirectory = Directory(dbDirectoryPath);
  if (!await dbDirectory.exists()) {
    await dbDirectory.create(recursive: true);
  }

  return File(p.join(dbDirectoryPath, 'db.sqlite'));

}
