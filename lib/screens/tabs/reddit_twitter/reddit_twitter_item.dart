import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/reddit_twitter_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/item_back.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class RedditTwitterItem extends StatelessWidget {
  final int index;
  final bool up;
  final SocialSentimentItemRes? data;
  const RedditTwitterItem(
      {this.up = true, super.key, required this.index, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, StockDetails.path,
            arguments: data?.symbol ?? "");
      },
      child: ItemBack(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.sp),
              child: Container(
                padding: EdgeInsets.all(5.sp),
                width: 43.sp,
                height: 43.sp,
                child: ThemeImageView(url: data?.image ?? ""),
              ),
            ),
            const SpacerHorizontal(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.symbol ?? "",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVerticel(height: 5),
                  Text(
                    data?.name ?? "",
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
            // const SpacerHorizontal(width: 8),
            // Text(
            //   "VERY BULLISH",
            //   style: stylePTSansRegular(fontSize: 10, color: ThemeColors.accent),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            const SpacerHorizontal(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data?.totalMentions.toString() ?? "",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVerticel(height: 5),
                Text(
                  data?.recentMentions ?? "",
                  style: stylePTSansRegular(
                    // color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // const SpacerHorizontal(width: 8),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Text(
            //       "+0.00%",
            //       style: stylePTSansRegular(
            //         fontSize: 12,
            //         color: ThemeColors.accent,
            //       ),
            //     ),
            //     const SpacerVerticel(height: 5),
            //     Text(
            //       "-0.00%",
            //       style: stylePTSansRegular(
            //         fontSize: 12,
            //         color: Colors.red,
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
