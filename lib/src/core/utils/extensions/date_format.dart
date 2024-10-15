import 'package:intl/intl.dart';

extension DateFormatExtension on String {
  String get formattedDateIntoYYYYMD =>
      DateFormat('yyyy/M/d', "en").format(DateTime.parse(this));
}
