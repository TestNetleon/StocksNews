import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class DrawerScreenTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? subTitle;

  const DrawerScreenTitle({
    this.title,
    this.style,
    super.key,
    this.subTitle,
  });
//
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: subTitle != null && subTitle != "",
      child: Container(
        margin: EdgeInsets.only(bottom: 10.sp),
        child: Text(
          subTitle ?? "",
          style: style ??
              stylePTSansRegular(fontSize: 14, color: ThemeColors.greyText),
        ),
      ),
    );
  }
}
