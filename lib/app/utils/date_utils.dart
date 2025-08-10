import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date, [String? format]) {
    format ??= 'dd/MM/yyyy';
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime date, [String? format]) {
    format ??= 'HH:mm';
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime date, [String? format]) {
    format ??= 'dd/MM/yyyy HH:mm';
    return DateFormat(format).format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = startOfDay(from);
    to = startOfDay(to);
    return to.difference(from).inDays;
  }

  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    List<DateTime> days = [];
    DateTime current = startOfDay(start);
    final endDate = startOfDay(end);

    while (!current.isAfter(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}