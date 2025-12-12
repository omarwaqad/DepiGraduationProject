import 'package:flutter/material.dart';

// Colors
class AppColors {
  static const Color primaryGreen = Color(0xFF219A6D);
  static const Color primaryGreenDark = Color(0xFF1C815B);
  static const Color primaryGreenLight = Color(0xFFE7F8EF);

  static const Color secondaryOrange = Color(0xFFDD755A);
  static const Color secondaryOrangeLight = Color(0xFFFFF2EE);

  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}

// Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: AppColors.textHint,
  );
}

// Dimensions
class AppDimensions {
  static const double defaultPadding = 16.0;
  static const double cardPadding = 12.0;
  static const double buttonRadius = 12.0;
  static const double cardRadius = 16.0;
}

// App Info
class AppInfo {
  static const String appName = 'دليلي';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'طريقك للأوراق الحكومية';
}
