import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/item_back.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class SocialSentimentMentions extends StatelessWidget {
  final RecentMention data;
  const SocialSentimentMentions({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, StockDetails.path,
          arguments: data.symbol),
      child: ItemBack(
        color: ThemeColors.background,
        // padding: EdgeInsets.fromLTRB(10.sp, 15.sp, 15.sp, 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.sp),
                        child: Container(
                          padding: EdgeInsets.all(5.sp),
                          width: 43.sp,
                          height: 43.sp,
                          child: ThemeImageView(
                              url: data.image ?? "", fit: BoxFit.contain),
                        ),
                      ),
                      Text(
                        data.symbol,
                        style: stylePTSansBold(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        maxLines: 2,
                        "${data.price}",
                        overflow: TextOverflow.ellipsis,
                        style: stylePTSansRegular(
                            fontSize: 12, color: ThemeColors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            (data.change ?? 0) > 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 15.sp,
                            color: (data.change ?? 0) > 0
                                ? ThemeColors.accent
                                : Colors.red,
                          ),
                          Flexible(
                            child: Text(
                              maxLines: 2,
                              "${data.change?.toCurrency()} (${data.changesPercentage?.toCurrency()}%)",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: (data.change ?? 0) > 0
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
            Padding(
              padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 2,
                    "${data.name}",
                    overflow: TextOverflow.ellipsis,
                    style: stylePTSansRegular(
                        fontSize: 15, color: ThemeColors.greyText),
                  ),
                  Text(
                    maxLines: 1,
                    (data.mentionCount ?? 1) == 1
                        ? "Mention - ${data.mentionCount}"
                        : "Mentions - ${data.mentionCount}",
                    overflow: TextOverflow.ellipsis,
                    style: stylePTSansRegular(
                        fontSize: 14, color: ThemeColors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
