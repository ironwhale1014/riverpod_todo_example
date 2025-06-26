import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final _fileName = "train5_db.db";

Future<File> get getDbFile async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, _fileName));
}
