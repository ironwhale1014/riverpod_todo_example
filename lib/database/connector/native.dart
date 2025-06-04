import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> get databaseFile async {
  final folder = await getApplicationDocumentsDirectory();
  return File(p.join(folder.path, 'sqlite/train_db.db'));
}
