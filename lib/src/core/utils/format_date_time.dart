import 'package:intl/intl.dart';

String formatDateTime(DateTime date) {
  final dateFormat = DateFormat('d MMM yyyy');
  return dateFormat.format(date);
}
