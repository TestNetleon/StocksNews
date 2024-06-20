import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

//
final lightTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: ThemeColors.primaryPalette,
  scaffoldBackgroundColor: ThemeColors.background,
  drawerTheme: const DrawerThemeData(
    backgroundColor: ThemeColors.background,
    width: double.infinity,
  ),
  appBarTheme: AppBarTheme(
    // iconTheme: IconThemeData(color: Colors.black),
    // backgroundColor: Colors.white,
    // foregroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: Fonts.roboto,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness:
          Platform.isAndroid ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.light : Brightness.dark,
    ),
  ),
  fontFamily: Fonts.roboto,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: ThemeData.light().textTheme.apply(
        displayColor: Colors.white,
        bodyColor: Colors.black,
        fontFamily: Fonts.roboto,
      ),
);

// TextStyle styleRobotoRegular({
//   color = Colors.white,
//   double fontSize = 15,
//   height = 1.3,
//   letterSpacing = 0.70,
//   decoration,
// }) {
//   return TextStyle(
//     fontSize: fontSize.sp,
//     color: color,
//     fontFamily: Fonts.roboto,
//     fontWeight: FontWeight.normal,
//     height: height,
//     decoration: decoration,
//     decorationColor: color,
//     letterSpacing: letterSpacing,
//   );
// }

// TextStyle styleRobotoBold({
//   color = Colors.white,
//   double fontSize = 16,
//   letterSpacing = 0.70,
//   decoration,
// }) {
//   return TextStyle(
//       fontSize: fontSize.sp,
//       color: color,
//       fontFamily: Fonts.roboto,
//       fontWeight: FontWeight.bold,
//       decoration: decoration,
//       decorationColor: color,
//       letterSpacing: letterSpacing);
// }

// TextStyle styleRobotoMedium({
//   color = Colors.white,
//   double fontSize = 16,
//   letterSpacing = 0.70,
//   decoration,
// }) {
//   return TextStyle(
//       fontSize: fontSize.sp,
//       color: color,
//       fontFamily: Fonts.roboto,
//       fontWeight: FontWeight.w500,
//       decoration: decoration,
//       decorationColor: color,
//       letterSpacing: letterSpacing);
// }

// TextStyle styleGeorgiaRegular({
//   color = Colors.white,
//   double fontSize = 15,
//   height = 1.2,
//   letterSpacing = 0.70,
//   decoration,
// }) {
//   return TextStyle(
//     fontSize: fontSize.sp,
//     color: color,
//     fontFamily: Fonts.georgia,
//     fontWeight: FontWeight.normal,
//     height: height,
//     decoration: decoration,
//     decorationColor: color,
//     // letterSpacing: letterSpacing,
//   );
// }

// TextStyle styleGeorgiaBold({
//   color = Colors.white,
//   double fontSize = 16,
//   letterSpacing = 0.70,
//   decoration,
// }) {
//   return TextStyle(
//     fontSize: fontSize.sp,
//     color: color,
//     fontFamily: Fonts.georgia,
//     fontWeight: FontWeight.bold,
//     decoration: decoration,
//     decorationColor: color,
//     // letterSpacing: letterSpacing,
//   );
// }

// TextStyle styleGeorgiaRegular({
//   color = Colors.white,
//   double fontSize = 15,
//   height = 1.2,
//   letterSpacing = 0.70,
//   decoration,
//   bool showSpacing = false,
// }) {
//   return TextStyle(
//     fontSize: fontSize.sp,
//     color: color,
//     fontFamily: Fonts.merriWeather,
//     fontWeight: FontWeight.normal,
//     height: height,
//     decoration: decoration,
//     decorationColor: color,
//     letterSpacing: showSpacing ? letterSpacing : 0.0,
//   );
// }

// TextStyle styleGeorgiaBold({
//   color = Colors.white,
//   double fontSize = 16,
//   letterSpacing = 0.70,
//   decoration,
// }) {
//   return TextStyle(
//     fontSize: fontSize.sp,
//     color: color,
//     fontFamily: Fonts.merriWeather,
//     fontWeight: FontWeight.bold,
//     decoration: decoration,
//     decorationColor: color,
//     // letterSpacing: letterSpacing,
//   );
// }

TextStyle styleGeorgiaRegular({
  color = Colors.white,
  double fontSize = 15,
  height = 1.2,
  letterSpacing = 0.70,
  decoration,
  bool showSpacing = false,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: Fonts.ptSans,
    fontWeight: FontWeight.normal,
    height: height,
    decoration: decoration,
    decorationColor: color,
    letterSpacing: showSpacing ? letterSpacing : 0.0,
  );
}

TextStyle styleGeorgiaBold({
  color = Colors.white,
  double fontSize = 16,
  letterSpacing = 0.70,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: Fonts.ptSans,
    fontWeight: FontWeight.bold,
    decoration: decoration,
    decorationColor: color,
    // letterSpacing: letterSpacing,
  );
}

TextStyle stylePTSansRegular({
  color = Colors.white,
  double fontSize = 15,
  height = 1.2,
  letterSpacing = 0.70,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: Fonts.ptSans,
    fontWeight: FontWeight.normal,
    height: height,
    decoration: decoration,

    decorationColor: color,
    // letterSpacing: letterSpacing,
  );
}

TextStyle stylePTSansBold({
  color = Colors.white,
  double fontSize = 16,
  letterSpacing = 0.70,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: Fonts.ptSans,
    fontWeight: FontWeight.bold,
    decoration: decoration,
    decorationColor: color,
    // letterSpacing: letterSpacing,
  );
}
