extension ConvertListStringDaysToStringExtension on List<String> {
  String toStringDays() {
    List<String> days = toSet().toList();
    String result = "";
    for (int i = 0; i < days.length; i++) {
      if (i != days.length - 1) {
        result += "${this[i]} - ";
      } else {
        result += this[i];
      }
    }

    return result;
  }
}
