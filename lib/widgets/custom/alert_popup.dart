import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

void popUpAlert({
  required String message,
  required String title,
  required String icon,
}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertPopupCustom(
        message: message,
        title: title,
        icon: icon,
      );
    },
  );
}

class AlertPopupCustom extends StatelessWidget {
  final String message, title, icon;
  const AlertPopupCustom({
    super.key,
    required this.message,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        backgroundColor: ThemeColors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5.sp),
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        icon,
                        height: 80.sp,
                        width: 80.sp,
                      ),
                      // const SpacerVertical(height: 5),
                      Text(
                        title,
                        style: stylePTSansBold(
                          color: ThemeColors.background,
                          fontSize: 20,
                        ),
                      ),
                      const SpacerVertical(height: 8),
                      Text(
                        message,
                        style:
                            stylePTSansRegular(color: ThemeColors.background),
                      ),
                      const SpacerVertical(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style:
                                stylePTSansBold(color: ThemeColors.background),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: ScreenUtil().screenWidth / 1.35,
              height: 5.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.sp),
                    bottomRight: Radius.circular(10.sp)),
                color: ThemeColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
