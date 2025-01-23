import 'package:flutter/material.dart';

class ThemeColors {
  static const MaterialColor primaryPalette = MaterialColor(
    0xFF000000, // Black color
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(0xFF000000), // Base color (black)
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor whitePalette = MaterialColor(
    0xFFFFFFFF, // Base color (white)
    <int, Color>{
      50: Color(0xFFFFFFFF), // 100% white
      100: Color(0xFFFAFAFA), // Slightly darker white
      200: Color(0xFFF5F5F5), // Light grayish white
      300: Color(0xFFEEEEEE), // Grayish white
      400: Color(0xFFE0E0E0), // Light gray
      500: Color(0xFFBDBDBD), // Mid gray (neutral)
      600: Color(0xFF9E9E9E), // Dark gray
      700: Color(0xFF757575), // Very dark gray
      800: Color(0xFF616161), // Near black
      900: Color(0xFF424242), // Almost black
    },
  );

//

  static const MaterialColor blackShade = MaterialColor(
    0xFF000000, // Black color
    <int, Color>{
      50: Color(0xFFE0E0E0), // Very Light Gray
      100: Color(0xFFBDBDBD), // Light Gray
      200: Color(0xFF9E9E9E), // Gray
      300: Color(0xFF757575), // Medium Gray
      400: Color(0xFF616161), // Dark Gray
      500: Color(0xFF424242), // Base color (black)
      600: Color(0xFF303030), // Darker Gray
      700: Color(0xFF212121), // Very Dark Gray
      800: Color(0xFF181818), // Almost Black
      900: Color(0xFF000000), // Black
    },
  );

  static const LinearGradient greyWhiteGradient = LinearGradient(
    colors: [Colors.grey, Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primary = Color(0xFF000000);
  static const primaryLight = Color(0xFF2C2C2C);
  static const background = Color(0xFF121212);
  // static const primaryLight = Color.fromARGB(255, 34, 34, 34);
  static const accent = Color(0xFF35BA46);
  static const tableBorderColor = Color.fromARGB(255, 59, 59, 59);

  static const progressbackgroundColor = Color(0xFFd29650);
  static const progressbackgroundColorDark = Color(0xFFb48245);

  static const darkGreen = Color(0xFF269238);
  static const darkRed = Color.fromARGB(255, 213, 14, 7);

  static const ratingIconColor = Color(0xFFfec107);
  static const golden = Color(0xFFFFD700);
  static const themeGreen = Color(0xFF14b24a);
  static const themeOrange = Color(0xfffa6c10);

  static const gredientColor = Color.fromARGB(78, 0, 0, 0);

  static const transparent = Color.fromARGB(78, 0, 0, 0);
  static const transparentDark = Color.fromARGB(220, 0, 0, 0);
  static const border = Color.fromRGBO(216, 216, 216, 1);
  static const divider = Color.fromRGBO(214, 213, 213, 1);
  static const dividerDark = Color.fromRGBO(151, 151, 151, 1);
  static const greyText = Color(0xFF97999E);
  static const greyBorder = Color(0xFF626262);
  static const gradientLight = Color(0xFF3B3C3E);
  static const gradientDark = Color(0xFF121212);
  static const transparentRed = Color.fromARGB(92, 247, 106, 106);
  static const lightRed = Color.fromARGB(255, 252, 111, 111);
  static const transparentGreen = Color.fromARGB(92, 146, 247, 106);
  static const lightGreen = Color.fromARGB(255, 111, 252, 120);
  static const sos = Color(0xFFF44336);
  static const blue = Color(0xFF21DEF3);
  static const white = Colors.white;
  static const bottomsheetGradient = Color.fromARGB(255, 0, 35, 5);
  static const buttonLightRed = Color.fromARGB(255, 252, 193, 189);
  static const buttonLightGreen = Color.fromARGB(255, 231, 253, 232);
  static const buttonBlue = Colors.blue;
  static const tabBack = Color.fromARGB(255, 32, 32, 32);
}
