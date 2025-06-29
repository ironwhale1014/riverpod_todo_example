import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> get getDbFile async {
  final dir = await getApplicationDocumentsDirectory();
  final dbFilePath = p.join(dir.path, 'train7.db');
  return File(dbFilePath);
}
