import 'package:intl/intl.dart';

String convertDateFormat(String inputDate) {
  final outputFormat = DateFormat('dd MMM yyyy');

  DateTime date = DateTime.parse(inputDate);
  String formattedDate = outputFormat.format(date);

  return formattedDate;
}
