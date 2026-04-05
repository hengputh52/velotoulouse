import 'package:flutter/material.dart';

///
/// Definition of App colors.
///
class AppColors {
  // Bellow colors never changes with theme :
  static Color primary = const Color(0xFF1275E2);
  static Color secondary = const Color(0xFF5F78A3);

  //static Color tertiary = const Color(0xFFEC8A2B);
  static Color background = const Color(0xFFFFFFFF);
  static Color neutralLight = const Color(0xFF74777F);

  static Color get backgroundColor {
    return AppColors.background;
  }

  static Color get text {
    return AppColors.primary;
  }

  static Color get textLight {
    return AppColors.secondary;
  }

  static Color get labelColor {
    return AppColors.background;
  }
}

///
/// Definition of App text styles.
///
class AppTextStyles {
  static TextStyle heading = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static TextStyle body = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static TextStyle label = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.labelColor,
  );
}

class BlaSpacings {
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 40;

  static const double radius = 16;
  static const double radiusLarge = 24;
}

///
/// Definition of App Theme.
///
ThemeData appTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Colors.white,
);
