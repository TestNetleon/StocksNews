// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sectorIndustry/sector_industry.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

//
class TrendingSectorItem extends StatelessWidget {
  final Sector data;
  const TrendingSectorItem({required this.data, super.key});

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cnts) {
        return InkWell(
          onTap: () {
            _navigateSector(context, data.sectorSlug, data.sector);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: cnts.maxWidth * .5,
                  child: Row(
                    children: [
                      // const Icon(
                      //   Icons.monitor_rounded,
                      //   color: ThemeColors.accent,
                      // ),
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
                      const SpacerHorizontal(width: 12),
                      Flexible(
                        child: Text(
                          data.sector ?? "",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  flex: 2,
                  child: Text(
                    data.mentionType ?? "",
                    style: stylePTSansRegular(
                      fontSize: 12,
                      color: ThemeColors.accent,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
                const SpacerHorizontal(),
                Text(
                  "${data.totalMentions}",
                  style: stylePTSansRegular(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
