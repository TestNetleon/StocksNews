import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class LinearBarCommon extends StatelessWidget {
  final num value;
  const LinearBarCommon({super.key, this.value = 0});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 2500,
      percent: value / 100,
      lineHeight: !isPhone ? 14.sp : 16.sp,
      barRadius: Radius.circular(5.sp),
      padding: EdgeInsets.only(right: 20.sp, top: 1.sp),
      backgroundColor: ThemeColors.greyBorder,
      center: Text(
        "$value%",
        style: stylePTSansBold(
          fontSize: 8,
        ),
      ),
      progressColor: value >= 0 && value < 25
          ? ThemeColors.sos
          : value >= 25 && value < 50
              ? Colors.orange
              : value >= 50 && value < 75
                  ? const Color.fromARGB(255, 106, 187, 59)
                  : const Color.fromARGB(255, 13, 126, 68),
    );
  }
}
