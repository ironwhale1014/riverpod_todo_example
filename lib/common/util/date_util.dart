import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

final DateFormat dateFormat = DateFormat.yMMMd();

Widget getDateFormat(DateTime? date) {
  if (date == null) {
    return Text("not set due date");
  }
  return Text(dateFormat.format(date));
}
