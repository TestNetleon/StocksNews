import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TopSnackbar {
  static OverlayEntry? _currentOverlayEntry;

  static void show({
    required String message,
    int seconds = 3,
    ToasterEnum type = ToasterEnum.info,
  }) {
    String? image;
    Color? iconColor;
    Color? bgColor;
    switch (type) {
      case ToasterEnum.success:
        image = Images.tickCircle;
        iconColor = ThemeColors.white;
        bgColor = ThemeColors.success120;

        break;
      case ToasterEnum.info:
        image = Images.infoCircle;
        iconColor = ThemeColors.black;
        bgColor = ThemeColors.white;

        break;

      case ToasterEnum.warning:
        image = Images.warningCircle;
        iconColor = ThemeColors.white;
        bgColor = ThemeColors.warning120;

        break;
      case ToasterEnum.error:
        image = Images.closeCircle;
        iconColor = ThemeColors.white;
        bgColor = ThemeColors.error120;

        break;
    }

    try {
      _removeCurrentSnackbar();

      final overlay = navigatorKey.currentState?.overlay;
      _currentOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50.sp,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeColors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (image != null && image != '')
                    Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset(
                        image,
                        height: 25.sp,
                        width: 25.sp,
                        color: iconColor,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: styleBaseRegular(
                        fontSize: 16,
                        color: ThemeColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      overlay?.insert(_currentOverlayEntry!);

      Future.delayed(Duration(seconds: seconds), () {
        _removeCurrentSnackbar();
      });
    } catch (e) {
      Utils().showLog('Error in toaster $e');
    }
  }

  static void _removeCurrentSnackbar() {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }
  }
}
