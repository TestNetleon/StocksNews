import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
Future<void> showSessionOutDialog(String? message, Function()? onpress) async {
  return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (isPoped) {
            SystemNavigator.pop();
          },
          child: AlertDialog(
            title: Text(message ?? ""),
            actions: <Widget>[
              TextButton(
                onPressed: onpress,
                child: Text(
                  'ok',
                  style: stylePTSansBold(fontSize: 16.sp),
                ),
              ),
            ],
          ),
        );
      });
}
