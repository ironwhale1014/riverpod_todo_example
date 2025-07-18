import 'package:intl/intl.dart';

final dateFormat = DateFormat.yMMMEd();

String dateTransfer(DateTime date) {
  return dateFormat.format(date);
}
