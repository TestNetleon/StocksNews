import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/screens/tabs/news/aiNews/detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TrendingStoriesItem extends StatelessWidget {
  final GeneralNew data;
  const TrendingStoriesItem({required this.data, super.key});
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => openUrl(data.url),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsAI(
              slug: data.slug,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text(
                //   "${data.site} / ${formatDateTimeAgo(data.publishedDate ?? DateTime.now())}",
                //   // "zacs.com / 21 hours ago",
                //   style: stylePTSansRegular(fontSize: 10),
                // ),
                Text(
                  data.title?.trim() ?? "",
                  style: stylePTSansRegular(fontSize: 16),
                ),

                const SpacerVertical(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By ",
                        style: stylePTSansRegular(
                          fontSize: 13,
                          color: ThemeColors.greyText,
                        ),
                      ),
                      TextSpan(
                        text: "${data.site?.trim()}",
                        style: stylePTSansRegular(
                          fontSize: 13,
                          color: ThemeColors.greyText,
                        ),
                      ),
                      TextSpan(
                        text:
                            " | ${formatDateTimeAgo(data.publishedDate ?? DateTime.now())}",
                        style: stylePTSansRegular(
                          fontSize: 13,
                          color: ThemeColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          ClipRRect(
            // borderRadius: BorderRadius.circular(Dimen.radius.r.sp),
            child: SizedBox(
              width: 100,
              height: 100,
              child: ThemeImageView(url: data.image ?? ""),
              // Image.network(news!.image, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
