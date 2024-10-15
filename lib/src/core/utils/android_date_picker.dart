import 'package:fatora/generated/l10n.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void androidDatePicker({
  required BuildContext context,
  required DateTime? selectedDate,
  required DateTime firstDate,
  DateTime? lastDate,
  required Function(DateTime?) onSelectDate,
  String helpText = "",
  List<DateTime>? activeDates,
}) async {
  var chosenDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? firstDate,
      firstDate: firstDate,
      helpText: helpText == "" ? S.of(context).selectDate : helpText,
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: ColorSchemes.primary)),
            child: child!);
      });

  if (chosenDateTime != null) {
    onSelectDate(chosenDateTime);
  } else {
    onSelectDate(null);
  }
}

