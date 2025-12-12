import 'package:intl/intl.dart';

class Helpers {
  /// Format date to Arabic time ago
  static String timeAgoArabic(DateTime? dateTime) {
    if (dateTime == null) return 'منذ وقت غير معلوم';

    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'منذ لحظات';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return 'منذ $m دقيقة';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return 'منذ $h ساعة';
    } else if (diff.inDays == 1) {
      return 'منذ يوم';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  /// Format date to readable string
  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
  }

  /// Format date to Arabic date
  static String formatDateArabic(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'إبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Calculate percentage
  static double calculatePercentage(int completed, int total) {
    if (total == 0) return 0.0;
    return completed / total;
  }

  /// Format percentage to string
  static String formatPercentage(double percentage) {
    return '${(percentage * 100).toInt()}%';
  }

  /// Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number (Egyptian format)
  static bool isValidEgyptianPhone(String phone) {
    final phoneRegex = RegExp(r'^(01)[0-9]{9}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
