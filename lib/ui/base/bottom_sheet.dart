import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';

import '../../routes/my_app.dart';

class BaseBottomSheet {
  bottomSheet({
    required Widget child,
    bool isScrollable = true,
    Color? barrierColor,
    EdgeInsets? padding,
  }) {
    ThemeManager manager = navigatorKey.currentContext!.read();
    bool isDark = manager.isDarkMode;

    showModalBottomSheet(
      isScrollControlled: isScrollable,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Pad.pad24),
          topRight: Radius.circular(Pad.pad24),
        ),
      ),
      enableDrag: true,
      barrierColor: barrierColor ??
          (isDark
              ? ThemeColors.black.withValues(alpha: .3)
              : ThemeColors.black),
      context: navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: padding ?? EdgeInsets.all(Pad.pad16),
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Pad.pad24),
                    topRight: Radius.circular(Pad.pad24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.black.withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: 5,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: OptionalParent(
                  addParent: !isScrollable,
                  parentBuilder: (ch) {
                    return child;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        child,
                      ],
                    ),
                  ),
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
          ),
        );
      },
    );
  }
}
