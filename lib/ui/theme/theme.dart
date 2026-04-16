import 'package:flutter/material.dart';

///
/// Definition of App colors.
///
class AppColors {
  static Color primary = const Color(0xFF1275E2);
  static Color secondary = const Color(0xFF5F78A3);
  static Color background = const Color(0xFFFFFFFF);
  static Color neutralLight = const Color(0xFF74777F);

  static Color get backgroundColorMain => AppColors.background;
  static Color get backgroundPrimary => AppColors.primary;
  static Color get textPrimary => AppColors.primary;
  static Color get textBody => AppColors.background;
  static Color get textLight => AppColors.secondary;
  static Color get labelColor => AppColors.background;
}

///
/// Definition of App text styles.
///
class AppTextStyles {
  // Non-const version (uses AppColors — fine outside const context)
  static TextStyle get heading => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Const version for use inside const widgets (e.g. const ListView children)
  static const TextStyle headingStatic = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1275E2),
  );

  static TextStyle get title => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static TextStyle get body => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
  );

  static TextStyle get label => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.labelColor,
  );
}

class AppSpacings {
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 40;

  static const double radius = 16;
  static const double radiusLarge = 24;
}

///
/// App Theme
///
ThemeData appTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Colors.white,
);
