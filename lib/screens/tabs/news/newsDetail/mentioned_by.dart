import 'package:flutter/material.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../modals/news_datail_res.dart';
import '../../../../widgets/cache_network_image.dart';

class NewsDetailMentionedBy extends StatelessWidget {
  final List<NewsTicker>? data;
  const NewsDetailMentionedBy({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    // NewsDetailProvider provider = context.watch<NewsDetailProvider>();
    // if (provider.data?.postDetail?.tickers?.isEmpty == true ||
    //     provider.data?.postDetail?.tickers == null) {
    //   return const SizedBox();
    // }

    if (data?.isEmpty == true || data == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: Dimen.itemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mentioned in Story",
            style: stylePTSansBold(),
          ),
          const SpacerVertical(height: 8),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                // provider.data?.postDetail?.tickers?.length ?? 0,
                data?.length ?? 0,

                (index) {
                  NewsTicker? tickers =
                      // provider.data?.postDetail?.tickers?[index];
                      data?[index];

                  return MentionedByItem(
                    tickers: tickers,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MentionedByItem extends StatelessWidget {
  final NewsTicker? tickers;
  const MentionedByItem({super.key, this.tickers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => StockDetail(
                symbol: tickers!.symbol!,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 23, 23, 23),
                // ThemeColors.greyBorder,
                Color.fromARGB(255, 39, 39, 39),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: SizedBox(
                  width: 43,
                  height: 43,
                  child: CachedNetworkImagesWidget(
                    tickers?.image ?? "",
                  ),
                ),
              ),
              const SpacerHorizontal(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tickers?.symbol ?? "",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    tickers?.name ?? "",
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
