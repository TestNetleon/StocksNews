import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/compare_sc_simmer/compare_bar_item_sc_simmer.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CompareFooterScreenSimmer extends StatelessWidget {
  const CompareFooterScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(),
          Container(
            width: 412.sp,
            color: ThemeColors.accent,
            height: 2,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
          const SpacerVertical(),
          const CompareBarItemScreenSimmer(),
          const SpacerVertical(height: 10),
          Container(
            color: ThemeColors.greyBorder,
            height: 2,
            width: 412.sp,
          ),
        ],
      ),
    );
  }
}
