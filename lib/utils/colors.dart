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
  // static const gold = Color(0xfff8f0c0);
  // static const silver = Color(0xffedf1f4);
  // static const bronze = Color(0xffccb593);
  static const blue = Color(0xFF21DEF3);
  static const bottomsheetGradient = Color.fromARGB(255, 0, 35, 5);
  static const buttonLightRed = Color.fromARGB(255, 252, 193, 189);
  static const buttonLightGreen = Color.fromARGB(255, 231, 253, 232);
  static const buttonBlue = Colors.blue;
  static const tabBack = Color.fromARGB(255, 32, 32, 32);
  static const green11 = Color.fromARGB(92, 19, 56, 4);

//New UI

  //PRIMARY
  static Color primary120 = Color(0xFF06C9BC);
  static Color primary100 = Color(0xFF17DBD1);
  static Color primary20 = Color(0xFF95E9E4);
  static const primary10 = Color(0xFFD7F6F5);

  //SECONDARY
  static Color secondary120 = Color(0xFF3240D1);
  static Color secondary100 = Color(0xFF555ED9);
  static Color secondaryD6 = Color(0xFF5856D6);
  static Color secondary20 = Color(0xFFC5C6F1);
  static Color secondary10 = Color(0xFFE8E8FA);

  //Neutral
  static Color neutral80 = Color(0xFF465F8C);
  static Color neutral60 = Color(0xFF59719B);
  static Color neutral40 = Color(0xFF6E85AE);
  static Color neutral20 = Color(0xFF98A7C2);
  static Color neutral10 = Color(0xFFC0C9DB);
  static Color neutral5 = Color(0xFFF0F2F6);
  static Color neutral6 = Color(0xFFCCCCCC);
  // static Color neutral7 = Color(0xFF243D4C);
  static Color neutral8 = Color(0xFF34373C);
  static Color neutral9 = Color(0xFFF9FDFB);

  // Category

  static Color category100 = Color(0xFF2784E1);

  //OTHER
  static Color black = Color(0xFF282B41);
  static Color white = Color(0xFFFFFFFF);
  static Color itemBack = Color(0xFFFFFFFF);
  static const splashBackground = Color(0xFF012054);
  static Color splashBG = Color(0xFF012054);
  static Color selectedBG = Color(0xFF012054);
  static Color colour66 = Color(0xFF666666);
  static Color colourBA = Color(0xFFBABABA);
  static Color disabledBtn = Color(0xFF3C3C43);
  static Color colour8d = Color(0xFF34928d);

  //CATEGORY
  static Color lightGrey = Color(0xFFF0F2F6);
  static Color gray2 = Color(0xFFAEAEB2);

  //FEEDBACK
  static Color success120 = Color(0xFF0AA870);
  static Color success100 = Color(0xFF47C189);
  static Color success = Color(0xFF47C189);
  static Color success10 = Color(0xFFEFFBF5);

  static Color warning120 = Color(0xFFEABF3B);
  static Color warning = Color(0xFFF6C941);
  static Color warning10 = Color(0xFFFDF4D9);

  static Color error120 = Color(0xFFFF4D4C);
  static Color error = Color(0xFFFC7272);
  static Color error10 = Color(0xFFFFF1F1);

  static Color orange120 = Color(0xFFFF7A00);
  static Color orange = Color(0xFFFFA500);
  static Color orange10 = Color(0xFFFFF4E5);

// Ranking
  static Color gold = Color(0xffe5a000);
  static Color silver = Color(0xffe6eaf0);
  static Color bronze = Color(0xffdeae80);

//Gradient
  static Color gradientGreen = Color(0xFF0E2900);
  static Color sliderDots = Color(0xFF181818);
  static Color boxShadow = Color(0x1C98A7C3);

  static Color navigationBar = Colors.white;

  static Color drawerMemDark = const Color(0xFF014680);
  static Color drawerMemLight = Color(0xFF358CBA);
  static Color drawerMemBtn = const Color(0xFF002053);

  static void updateTheme(bool isLightTheme) {
    drawerMemDark = isLightTheme ? const Color(0xFF014680) : gradientGreen;
    drawerMemLight = isLightTheme ? Color(0xFF358CBA) : const Color(0xFF35BA46);
    drawerMemBtn =
        isLightTheme ? const Color(0xFF002053) : const Color(0xFF035F00);
    //
    sliderDots = isLightTheme ? Colors.white : Color(0xFF181818);

    //  PRIMARY
    primary120 = isLightTheme ? Color(0xFF06C9BC) : ThemeColors.accent;
    primary100 = isLightTheme ? Color(0xFF17DBD1) : ThemeColors.accent;
    primary20 = Color(0xFF95E9E4);

    // SECONDARY
    secondary120 = isLightTheme ? Color(0xFF3240D1) : ThemeColors.accent;
    secondary100 = isLightTheme ? Color(0xFF555ED9) : ThemeColors.accent;
    // secondary10 = isLightTheme ? Color(0xFFE8E8FA) : Color(0xFF333333);
    // Neutral
    // neutral80 = isLightTheme ? Color(0xFF465F8C) : Color(0xFF98A7C2);

    navigationBar = isLightTheme ? Colors.black : ThemeColors.accent;
    // secondary120 = isLightTheme ? Color(0xFF3240D1) : ThemeColors.accent;

    neutral80 = isLightTheme ? Color(0xFF465F8C) : Color(0xFFFFFFFF);
    neutral60 = isLightTheme
        ? Color(0xFF59719B)
        : Color(0xFFFFFFFF).withValues(alpha: .8);
    neutral40 = isLightTheme
        ? Color(0xFF6E85AE)
        : Color(0xFFFFFFFF).withValues(alpha: .8);
    neutral20 = isLightTheme
        ? Color(0xFF98A7C2)
        : Color(0xFFFFFFFF).withValues(alpha: .8);
    neutral10 = Color(0xFFC0C9DB);
    neutral5 = isLightTheme ? Color(0xFFF0F2F6) : Color(0xFF333333);
    neutral6 = Color(0xFFCCCCCC);
    // neutral7 = Color(0xFF243D4C);
    neutral8 = Color(0xFF34373C);
    neutral9 = Color(0xFFF9FDFB);

    // Category
    category100 = Color(0xFF2784E1);

    // OTHER
    black = isLightTheme ? Color(0xFF282B41) : Color(0xFFFFFFFF);
    white = isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF000000);
    itemBack = isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF121212);
    // white = Color(0xFFFFFFFF);
    splashBG = isLightTheme ? Color(0xFF012054) : Color(0xFFFFFFFF);
    selectedBG = isLightTheme ? Color(0xFF012054) : ThemeColors.accent;
    colour66 = Color(0xFF666666);
    colourBA = Color(0xFFBABABA);
    disabledBtn = isLightTheme ? Color(0xFF3C3C43) : Color(0xFF262626);
    colour8d = Color(0xFF34928d);

    //CATEGORY
    lightGrey = Color(0xFFF0F2F6);
    gray2 = Color(0xFFAEAEB2);

    //FEEDBACK
    success120 = Color(0xFF0AA870);
    success100 = Color(0xFF47C189);
    success = Color(0xFF47C189);
    success10 = Color(0xFFEFFBF5);

    warning120 = Color(0xFFEABF3B);
    warning = Color(0xFFF6C941);
    warning10 = Color(0xFFFDF4D9);

    error120 = Color(0xFFFF4D4C);
    error = Color(0xFFFC7272);
    error10 = Color(0xFFFFF1F1);

    orange120 = Color(0xFFFF7A00);
    orange = Color(0xFFFFA500);
    orange10 = Color(0xFFFFF4E5);

    // Ranking
    gold = Color(0xffe5a000);
    silver = Color(0xffe6eaf0);
    bronze = Color(0xffdeae80);
  }
}
