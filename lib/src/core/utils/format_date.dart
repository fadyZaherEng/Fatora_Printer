import 'package:intl/intl.dart';

String formatDate(String date) {
  String formattedDate = "";
  try {
    DateTime originalDate = DateTime.parse(date);
    formattedDate = DateFormat('d MMM y').format(originalDate);
  } catch (e) {
    formattedDate = "";
  }

  return formattedDate;
}
