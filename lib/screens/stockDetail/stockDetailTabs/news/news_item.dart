import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_news.dart';
import 'package:stocks_news_new/screens/tabs/news/aiNews/detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdNewsItem extends StatelessWidget {
  final TopPost? news;
  final bool showCategory;
  final bool gotoDetail;
  const SdNewsItem({
    this.news,
    this.showCategory = true,
    this.gotoDetail = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => openUrl(news?.url),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsAI(slug: news?.slug),
            ));
      },

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news?.title ?? "",
                  style: styleGeorgiaBold(fontSize: 16),
                ),
                const SpacerVertical(height: 5),
                Visibility(
                  visible: showCategory,
                  child: Column(
                    children: [
                      if (news?.site == "" || news?.site == null)
                        Text(
                          "${news?.postDate}",
                          style: stylePTSansRegular(
                            fontSize: 13,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      if (!(news?.site == "" || news?.site == null))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Source - ${news?.site}",
                              style: stylePTSansRegular(
                                  fontSize: 13, color: ThemeColors.greyText),
                            ),
                            const SpacerVertical(height: 2),
                            Text(
                              "${news?.postDate}",
                              style: stylePTSansRegular(
                                  fontSize: 13, color: ThemeColors.greyText),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          CachedNetworkImagesWidget(
            news?.image ?? "",
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class SdNewsItemSeparated extends StatelessWidget {
  final TopPost? news;
  final bool showCategory;
  final bool gotoDetail;
  final bool fromMoreNews;
  const SdNewsItemSeparated({
    this.news,
    this.showCategory = true,
    this.gotoDetail = true,
    super.key,
    this.fromMoreNews = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsAI(slug: news?.slug),
            ));
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 6 / 3,
            child: CachedNetworkImagesWidget(
              news?.image,
              width: double.infinity,
            ),
          ),
          const SpacerVertical(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                news?.title ?? "",
                style: styleGeorgiaBold(fontSize: 24),
              ),
              const SpacerVertical(height: 5),
              Visibility(
                visible: showCategory,
                child: Text(
                  news?.site == "" || news?.site == null
                      ? "${news?.postDate}"
                      : "Source - ${news?.site} | ${news?.postDate}",
                  style: stylePTSansRegular(
                      fontSize: 13, color: ThemeColors.greyText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
