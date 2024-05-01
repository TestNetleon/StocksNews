import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../../../widgets/spacer_horizontal.dart';
import '../../../../widgets/spacer_verticle.dart';

class SocialSentimentMentions extends StatelessWidget {
  final RecentMention data;
  const SocialSentimentMentions({super.key, required this.data});
//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, StockDetails.path,
          arguments: data.symbol),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.sp),
                child: Container(
                  padding: EdgeInsets.all(5.sp),
                  width: 43.sp,
                  height: 43.sp,
                  child: ThemeImageView(url: data.image ?? ""),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.symbol,
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVerticel(height: 5),
                    Text(
                      data.name ?? "",
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      maxLines: 2,
                      "${data.price}",
                      overflow: TextOverflow.ellipsis,
                      style: stylePTSansRegular(
                          fontSize: 14, color: ThemeColors.white),
                    ),
                    const SpacerVerticel(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          (data.change ?? 0) > 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 14.sp,
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
                    const SpacerVerticel(height: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 1,
                          (data.mentionCount ?? 1) == 1
                              ? "Mention: ${data.mentionCount}"
                              : "Mentions: ${data.mentionCount}",
                          overflow: TextOverflow.ellipsis,
                          style: stylePTSansRegular(
                              fontSize: 12, color: ThemeColors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
