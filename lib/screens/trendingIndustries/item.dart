import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/trending_industries_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sectorIndustry/sector_industry.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TrendingIndustryItem extends StatelessWidget {
  final TrendingIndustriesRes data;
  const TrendingIndustryItem({super.key, required this.data});

  void _navigateSector(context, name, titleName) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => SectorIndustry(
          name: name,
          stockStates: StockStates.sector,
          titleName: titleName,
        ),
      ),
    );
  }

//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.sp),
      onTap: () => _navigateSector(context, data.industrySlug, data.industry),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                data.image == "" ||
                        data.image ==
                            "https://app.stocks.news/front/images/no_image.png"
                    ? Image.asset(
                        Images.monitor,
                        color: ThemeColors.accent,
                        height: 43,
                        width: 43,
                      )
                    : ThemeImageView(
                        url: data.image ?? "",
                        height: 43,
                        width: 43,
                      ),
                const SpacerHorizontal(width: 8),
                Flexible(
                  child: Text(
                    data.industry ?? "",
                    style: stylePTSansRegular(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 3),
          SizedBox(
            width: 50.sp,
            child: AutoSizeText(
              textAlign: TextAlign.center,
              data.mentionType ?? "",
              style: stylePTSansRegular(
                fontSize: 12,
                color: data.mentionType == "Very Bullish"
                    ? ThemeColors.accent
                    : ThemeColors.sos,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SpacerHorizontal(width: 3),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${data.totalMentions ?? 0}\n",
                      style: stylePTSansRegular(
                        fontSize: 12,
                        color: ThemeColors.white,
                      ),
                    ),
                    TextSpan(
                      text: "${data.mentionChange?.toCurrency() ?? 0}%",
                      style: stylePTSansRegular(
                        fontSize: 12,
                        color: (data.mentionChange ?? 0) > 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
