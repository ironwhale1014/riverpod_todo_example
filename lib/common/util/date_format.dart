import 'package:intl/intl.dart';

String getDateToString(DateTime dateTime) {
  final format = DateFormat.yMMMEd();
  return format.format(dateTime);
}
