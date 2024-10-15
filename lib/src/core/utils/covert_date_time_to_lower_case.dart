import 'package:fatora/src/core/utils/convert_string_to_date_format.dart';
import 'package:intl/intl.dart';

String covertDateTimeToLowerCase(String dateTime) {
  final DateFormat formatter = DateFormat('h:mm a');
  String formatted = formatter.format(
      dateTime == "" ? DateTime.now() : convertStringToDateFormat(dateTime));
  return formatted.replaceAll('AM', 'am').replaceAll('PM', 'pm');
}
