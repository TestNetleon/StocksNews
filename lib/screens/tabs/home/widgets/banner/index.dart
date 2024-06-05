import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: const Color.fromARGB(255, 191, 248, 198),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.close,
              color: ThemeColors.background,
            ),
          ),
          Row(
            children: [
              // Image.asset(
              //   Images.alertTickGIF,
              //   height: 70.sp,
              //   width: 70.sp,
              // ),
              // const SpacerHorizontal(width: 5),
              Text(
                "Create Stock Alerts",
                style: stylePTSansBold(color: ThemeColors.background),
              ),
            ],
          ),
          Text(
            "Selected wide range of stocks and add them into alerts.",
            style: stylePTSansBold(fontSize: 14, color: ThemeColors.background),
          ),
          const SpacerVertical(height: 25),
        ],
      ),
    );
  }
}
