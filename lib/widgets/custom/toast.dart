import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';

class CommonToast {
  static bool _isShowing = false;

  static void show({
    required String message,
    int duration = 1,
    Color? backgroundColor,
    Color textColor = Colors.white,
    double fontSize = 12.0,
  }) {
    if (!_isShowing) {
      _isShowing = true;

      Fluttertoast.showToast(
        msg: message,
        toastLength: duration == 1 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: backgroundColor ?? ThemeColors.greyBorder,
        textColor: textColor,
        fontSize: fontSize,
      );

      // Reset the flag after the toast is expected to disappear
      Future.delayed(Duration(seconds: duration), () {
        _isShowing = false;
      });
    }
  }
}
