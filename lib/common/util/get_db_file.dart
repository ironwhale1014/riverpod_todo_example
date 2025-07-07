import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> get getDbFile async {
  final directory = await getApplicationDocumentsDirectory();
  final dbFilePath = p.join(directory.path, 'db/train8.db');

  return File(dbFilePath);
}
