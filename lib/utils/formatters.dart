import 'package:intl/intl.dart';

class Formatters {
  static final RegExp _trailingZeros = RegExp(r'\.?0+$');
  static final DateFormat _date = DateFormat('EEE, d MMM yyyy');
  static final DateFormat _time = DateFormat('HH:mm');

  static String price(double amount) {
    final text = amount.toStringAsFixed(3).replaceFirst(_trailingZeros, '');
    return '$text JD';
  }

  static String pricePerHour(double amount) => '${price(amount)} / hour';

  static String capacity(int people) {
    return people == 1 ? '1 person' : 'Up to $people people';
  }

  static String hours(int count) => count == 1 ? '1 hour' : '$count hours';

  static String date(DateTime value) => _date.format(value);

  static String timeRange(DateTime start, DateTime end) {
    return '${_time.format(start)} - ${_time.format(end)}';
  }
}
