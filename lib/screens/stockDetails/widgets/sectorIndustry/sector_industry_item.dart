import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/sector_industry_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class SectorIndustryItem extends StatelessWidget {
  final int index;
  final SectorIndustryData? data;
  const SectorIndustryItem({super.key, required this.index, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, StockDetails.path,
            arguments: data?.symbol);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25.sp),
            child: Container(
              padding: EdgeInsets.all(5.sp),
              width: 43.sp,
              height: 43.sp,
              child: ThemeImageView(url: "${data?.image}"),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data?.symbol}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVerticel(height: 5),
                Text(
                  "${data?.name}",
                  style: stylePTSansRegular(
                    color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${data?.price}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVerticel(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: (data?.changesPercentage ?? 0) > 0
                          ? ThemeColors.accent
                          : Colors.red,
                      size: 16.sp,
                    ),
                    Flexible(
                      child: Text(
                        "${data?.change.toCurrency()}(${data?.changesPercentage.toCurrency()}%)",
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: (data?.changesPercentage ?? 0) > 0
                              ? ThemeColors.accent
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
