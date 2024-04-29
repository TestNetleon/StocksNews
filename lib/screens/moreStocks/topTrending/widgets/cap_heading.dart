import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class TrendingMarketCapHeading extends StatelessWidget {
  final String leading;
  final String trailing;
  const TrendingMarketCapHeading(
      {super.key, required this.leading, required this.trailing});
//
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leading,
                style: stylePTSansBold(fontSize: 13),
              ),
              const SpacerHorizontal(width: 5),
              Flexible(
                child: Text(
                  trailing,
                  style: stylePTSansBold(fontSize: 13),
                ),
              ),
            ],
          ),
          Divider(
            color: ThemeColors.border,
            height: 10.sp,
          ),
        ],
      ),
    );
  }
}
