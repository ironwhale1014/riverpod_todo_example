import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> get getDbFile async {
  final baseDir = await getApplicationDocumentsDirectory();
  final dbDir = Directory(p.join(baseDir.path, 'db'));
  if (dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }
  final dbFile = p.join(dbDir.path, 'todo.sqlite');

  return File(dbFile);
}
