import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../routes/my_app.dart';

class BaseBottomSheet {
  bottomSheet({
    required Widget child,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Pad.pad24),
          topRight: Radius.circular(Pad.pad24),
        ),
      ),
      enableDrag: true,
      barrierColor: ThemeColors.black,
      context: navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 14),
              padding: EdgeInsets.all(Pad.pad16),
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Pad.pad24),
                  topRight: Radius.circular(Pad.pad24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ThemeColors.white,
              ),
              height: 6,
              width: 48.sp,
            ),
          ],
        );
      },
    );
  }
}
