import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TrendingFilter extends StatelessWidget {
  const TrendingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: ThemeColors.accent,
          padding: EdgeInsets.symmetric(
            horizontal: 8.sp,
            vertical: 5.sp,
          ),
          child: Text(
            "Hot Stocks",
            style: stylePTSansBold(),
          ),
        ),
        const SpacerVerticel(height: 8),
        Text(
          "Top trending Stocks in outline chatter, past 7 days",
          style: stylePTSansRegular(fontSize: 12),
        ),
        const SpacerVerticel(height: 10),
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.primaryLight,
            border: Border.all(color: ThemeColors.greyBorder, width: 1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimen.itemSpacing.sp,
            vertical: 6.sp,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Time Period",
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 12,
                ),
              ),
              const SpacerHorizontal(),
              Text(
                "Week",
                style: stylePTSansRegular(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ThemeColors.greyText,
                size: 18.sp,
              ),
            ],
          ),
        ),
        const SpacerVerticel(height: 8),
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.primaryLight,
            border: Border.all(color: ThemeColors.greyBorder, width: 1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimen.itemSpacing.sp,
            vertical: 6.sp,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Type",
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 12,
                ),
              ),
              const SpacerHorizontal(),
              Text(
                "Sentiment",
                style: stylePTSansRegular(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ThemeColors.greyText,
                size: 18.sp,
              ),
            ],
          ),
        ),
        const SpacerVerticel(height: 8),
        const SpacerVerticel(height: 8),
      ],
    );
  }
}
