import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class AlertWatchlistButton extends StatelessWidget {
  final void Function()? onTap;
  final Color backgroundColor;
  final IconData iconData;
  final String name;
  const AlertWatchlistButton(
      {super.key,
      this.onTap,
      this.backgroundColor = ThemeColors.accent,
      required this.iconData,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: ThemeColors.background,
          disabledForegroundColor: ThemeColors.border,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              iconData,
              size: 15.sp,
            ),
            const SpacerHorizontal(width: 5),
            Text(
              name,
              style: stylePTSansBold(fontSize: 12),
            ),
            Visibility(
              visible: iconData == Icons.notifications && name == "Alert Added",
              child: Padding(
                padding: EdgeInsets.only(left: 2.sp),
                child: Icon(
                  Icons.check,
                  color: ThemeColors.accent,
                  size: 15.sp,
                ),
              ),
            ),
            Visibility(
              visible: iconData == Icons.star && name == "Watchlist Added",
              child: Padding(
                padding: EdgeInsets.only(left: 2.sp),
                child: Icon(
                  Icons.check,
                  color: ThemeColors.accent,
                  size: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
