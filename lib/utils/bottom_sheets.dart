import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../widgets/bottom_sheet_tick.dart';

class BaseBottomSheets {
  gradientBottomSheet({
    required Widget child,
    String? title,
    String? subTitle,
    EdgeInsets? padding,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      enableDrag: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Container(
          padding: padding ?? const EdgeInsets.fromLTRB(15, 0, 15, 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border(
              top: BorderSide(color: ThemeColors.greyBorder.withOpacity(0.4)),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 23, 23, 23),
                Color.fromARGB(255, 48, 48, 48),
              ],
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: ScreenUtil().screenHeight * .9,
          ),
          // height: 100,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: BottomSheetTick(),
                    ),
                  ),
                  Visibility(
                    visible: title != null && title != '',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ScreenTitle(title: title, subTitle: subTitle),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
