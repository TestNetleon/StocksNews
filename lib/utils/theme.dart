import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

final lightTheme = ThemeData(
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
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: Fonts.sdPRO,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      // statusBarColor: Colors.black,
      // statusBarIconBrightness: Brightness.light,
      // statusBarBrightness:
      //     Platform.isAndroid ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
  fontFamily: Fonts.sdPRO,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: ThemeData.light().textTheme.apply(
        displayColor: Colors.white,
        bodyColor: Colors.black,
        fontFamily: Fonts.sdPRO,
      ),
);

TextStyle styleGeorgiaRegular({
  color = ThemeColors.black,
  double fontSize = 15,
  FontStyle? fontStyle,
  height = 1.2,
  letterSpacing = 0.70,
  TextDecoration? decoration,
  bool showSpacing = false,
}) {
  return TextStyle(
    fontStyle: fontStyle,
    fontSize: fontSize,
    color: color,
    fontFamily: Fonts.sdPRO,
    fontWeight: FontWeight.normal,
    height: height,
    decoration: decoration,
    decorationColor: color,
    letterSpacing: showSpacing ? letterSpacing : 0.0,
  );
}

TextStyle styleGeorgiaBold({
  color = ThemeColors.black,
  double fontSize = 16,
  letterSpacing = 0.70,
  FontStyle? fontStyle,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: Fonts.sdPRO,
    fontWeight: FontWeight.bold,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationColor: color,
    // letterSpacing: letterSpacing,
  );
}

TextStyle stylePTSansRegular({
  color = ThemeColors.black,
  double fontSize = 15,
  height = 1.2,
  letterSpacing = 0.70,
  decoration,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  String? fontFamily,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily ?? Fonts.sdPRO,
    fontWeight: fontWeight ?? FontWeight.normal,
    height: height,
    decoration: decoration,
    fontStyle: fontStyle,
    decorationColor: color,
    // letterSpacing: letterSpacing,
  );
}

TextStyle stylePTSansBold({
  color = ThemeColors.black,
  double fontSize = 16,
  letterSpacing = 0.70,
  String? fontFamily,
  height = 1.2,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily ?? Fonts.sdPRO,
    fontWeight: FontWeight.bold,
    decoration: decoration,
    decorationColor: color,
    height: height,

    // letterSpacing: letterSpacing,
  );
}

TextStyle styleSansBold({
  color = ThemeColors.black,
  double fontSize = 16,
  letterSpacing = 0.70,
  height = 1.2,
  String? fontFamily,
  decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: fontFamily ?? Fonts.sdPRO,
    fontWeight: FontWeight.bold,
    decoration: decoration,
    decorationColor: color,
    height: height,

    // letterSpacing: letterSpacing,
  );
}

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
    fontFamily: fontFamily ?? Fonts.sdPRO,
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
    fontFamily: fontFamily ?? Fonts.sdPRO,
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
    fontFamily: fontFamily ?? Fonts.sdPRO,
    fontWeight: FontWeight.w600,
    decoration: decoration,
    decorationColor: color,
    height: height,
  );
}
