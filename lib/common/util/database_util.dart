import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String dbName = 'train_3_mk2.db';

Future<File> get getDatabaseFile async {
  final dirPath = await getApplicationDocumentsDirectory();
  return File(p.join(dirPath.path, dbName));
}