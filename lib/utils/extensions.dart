import 'dart:math';

import 'package:intl/intl.dart';

extension NumEx on num {
  String get currencyFormat =>
      NumberFormat.simpleCurrency(name: 'Rs ', decimalDigits: 0).format(this);
}

extension IntEx on int {
  String get weekDayString {
    return ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][this - 1];
  }
}

extension DateEx on DateTime {
  String get readableFormat => DateFormat.yMMMMd().format(this);
  String get dayMonthYear => DateFormat('dd MMM, yyyy').format(this);
  String get dayMonth => DateFormat('dd MMM').format(this);
  bool isSameDayAs(DateTime other) =>
      day == other.day && month == other.month && year == other.year;
}

extension ListEx<T> on List<T> {
  T get randomItem => this[Random().nextInt(length)];
  T? firstWhereOrNull(bool Function(T) predicate) {
    try {
      return firstWhere(predicate);
    } on StateError catch (_) {
      return null;
    }
  }
}
