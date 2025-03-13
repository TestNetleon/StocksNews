import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/aiAnalysis/tabs/overview/performance/index.dart';
import 'package:stocks_news_new/utils/colors.dart';

class AIRangeProgressBar extends StatelessWidget {
  final num weekLow;
  final num weekHigh;
  final num todayLow;
  final num todayHigh;
  final Color color;
  final num currentPrice;

  const AIRangeProgressBar({
    super.key,
    required this.weekLow,
    required this.color,
    required this.weekHigh,
    required this.todayLow,
    required this.todayHigh,
    required this.currentPrice,
  });

  @override
  Widget build(BuildContext context) {
    double rangeStart = (todayLow - weekLow) / (weekHigh - weekLow);
    double rangeEnd = (todayHigh - weekLow) / (weekHigh - weekLow);

    return Container(
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: ThemeColors.neutral5,
        // color: Colors.blue,
      ),
      child: Stack(
        children: [
          Positioned(
            left: ((msWidthPadding) * rangeStart) - 55,
            child: Container(
              height: 8,
              width: (msWidthPadding) * (rangeEnd - rangeStart),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
