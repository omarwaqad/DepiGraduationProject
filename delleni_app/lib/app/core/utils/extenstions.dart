import 'package:delleni_app/app/core/utils/helpers.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isSmallScreen => screenWidth < 360;
  bool get isTablet => screenWidth > 600;
  bool get isDesktop => screenWidth > 1200;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

extension StringExtensions on String {
  String get trimmed => trim();
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;

  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String get arabicDigits {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return replaceAllMapped(
      RegExp(r'\d'),
      (match) => arabicDigits[int.parse(match.group(0)!)],
    );
  }
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> whereNotNull() =>
      where((element) => element != null).cast<T>().toList();
}

extension DateTimeExtensions on DateTime {
  String get timeAgoArabic => Helpers.timeAgoArabic(this);
  String get formattedDate => Helpers.formatDate(this);
  String get formattedDateArabic => Helpers.formatDateArabic(this);

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}
