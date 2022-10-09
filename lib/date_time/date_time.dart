import 'package:intl/intl.dart';

//return todays date to yyyymmdd
String todaysDateFormatted() {
  var dateTimeObj = DateTime.now();
  return DateFormat('yyyyMMdd').format(dateTimeObj);
}

//create datetime object from string yyyyMMdd

DateTime createDateTimeObj(String yyyyMMdd) {
  int yyyy = int.parse(yyyyMMdd.substring(0, 4));
  int MM = int.parse(yyyyMMdd.substring(4, 6));
  int dd = int.parse(yyyyMMdd.substring(6, 8));
  DateTime dateTimeObj = DateTime(yyyy, MM, dd);

  return dateTimeObj;
}

//datetime Obj to string yyyyMMdd format

String convertDateTimeToString(DateTime dateTime) {
  return DateFormat('yyyyMMdd').format(dateTime).toString();
}
