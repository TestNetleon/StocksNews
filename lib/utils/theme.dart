import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

final lightTheme = ThemeData(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: ThemeColors.black,
  ),
  brightness: Brightness.light,
  useMaterial3: false,
  primarySwatch: ThemeColors.primaryPalette,
  scaffoldBackgroundColor: ThemeColors.white,
  drawerTheme: const DrawerThemeData(
    backgroundColor: ThemeColors.background,
    width: double.infinity,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: styleBaseBold(color: ThemeColors.black, fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
  fontFamily: Fonts.roboto,
  iconTheme: const IconThemeData(color: ThemeColors.black),
  textTheme: getTextTheme(ThemeColors.black),
);

final darkTheme = ThemeData(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: ThemeColors.white,
  ),
  brightness: Brightness.dark,
  useMaterial3: false,
  primarySwatch: ThemeColors.primaryPalette,
  scaffoldBackgroundColor: Colors.black,
  drawerTheme: const DrawerThemeData(
    backgroundColor: ThemeColors.black,
    width: double.infinity,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: styleBaseBold(color: Colors.white, fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  ),
  fontFamily: Fonts.roboto,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: getTextTheme(ThemeColors.white),
);

//MARK:only below in use for new design
TextStyle styleBaseBold({
  color = ThemeColors.black,
  double fontSize = 16,
  letterSpacing = 0.70,
  height = 0.0,
  String? fontFamily,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily ?? Fonts.roboto,
    fontWeight: FontWeight.w800,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
}

TextStyle styleBaseRegular({
  color = ThemeColors.black,
  double fontSize = 16,
  letterSpacing = 0.70,
  height = 0.0,
  String? fontFamily,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily ?? Fonts.roboto,
    fontWeight: FontWeight.w400,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
}

TextStyle styleBaseSemiBold({
  color = ThemeColors.black,
  double fontSize = 16,
  letterSpacing = 0.70,
  height = 0.0,
  String? fontFamily,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily ?? Fonts.roboto,
    fontWeight: FontWeight.w600,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
}

TextTheme getTextTheme(Color color) {
  return TextTheme(
    // Heading
    headlineLarge: styleBaseBold(color: color, fontSize: 18), //18 fonts App Bar

    // Page Titles
    titleLarge:
        styleBaseBold(color: color, fontSize: 28), //28 Screen Main Style

    // Display
    displayLarge: styleBaseBold(color: color, fontSize: 16), //16 Widget Styles
    displayMedium: styleBaseSemiBold(color: color, fontSize: 16),
    displaySmall: styleBaseRegular(color: color, fontSize: 16),

    // Small Fonts
    bodyLarge: styleBaseRegular(color: color, fontSize: 14),
    bodyMedium: styleBaseSemiBold(color: color, fontSize: 14),
    bodySmall: styleBaseRegular(color: color, fontSize: 14),

    // Sub Small Fonts
    labelLarge: styleBaseBold(color: color, fontSize: 13),
    labelMedium: styleBaseSemiBold(color: color, fontSize: 13),
    labelSmall: styleBaseRegular(color: color, fontSize: 13),
  );
}
