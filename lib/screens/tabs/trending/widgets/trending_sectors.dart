import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_sectors_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TrendingSectors extends StatelessWidget {
  const TrendingSectors({super.key});

  @override
  Widget build(BuildContext context) {
    // TrendingProvider provider = context.watch<TrendingProvider>();
//
    TrendingRes? data = context.read<TrendingProvider>().trendingStories;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ColoredText(
        //   text: "Trending Sectors",
        //   coloredLetters: const ["S"],
        //   style: stylePTSansBold(),
        // ),
        // Text(
        //   "Trending Sectors",
        //   style: stylePTSansBold(fontSize: 14),
        // ),
        // const SpacerVerticel(height: 5),

        // Text(
        //   "Top trending sectors in online chatter, Past 7 days",
        //   style: stylePTSansRegular(fontSize: 12),
        // ),
        // const ScreenTitle(
        //   title: "Trending Sectors",
        //   subTitle: "Top trending sectors in online chatter, Past 7 days",
        // ),
        Text(
          "Top trending sectors in online chatter, Past 7 days",
          style: stylePTSansRegular(fontSize: 13, color: ThemeColors.greyText),
        ),
        const SpacerVerticel(),
        ListView.separated(
          itemCount: data?.sectors?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Sector sectorData = (data?.sectors![index])!;
            return TrendingSectorItem(data: sectorData);
          },
          separatorBuilder: (BuildContext context, int index) {
            // return const SpacerVerticel(height: 8);
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            );
          },
        ),
        // const SpacerVerticel(height: Dimen.itemSpacing),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: ThemeButtonSmall(
        //     onPressed: () {},
        //     text: "View All",
        //   ),
        // )
      ],
    );
  }
}
