class DateTimeHelper {
  DateTimeHelper._();

  static String compactDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _monthLabels[date.month - 1];
    return '$month $day, ${date.year}';
  }

  static const List<String> _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
