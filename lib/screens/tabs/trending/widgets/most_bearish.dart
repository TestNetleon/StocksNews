import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MostBearish extends StatelessWidget {
  const MostBearish({super.key});
//
  @override
  Widget build(BuildContext context) {
    // TrendingProvider provider = context.watch<TrendingProvider>();
    TrendingRes? data = context.watch<TrendingProvider>().mostBearish;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     // ColoredText(
        //     //   text: "Most Bearish",
        //     //   coloredLetters: const ["B"],
        //     //   color: Colors.red,
        //     //   style: stylePTSansBold(),
        //     // ),
        //     const Icon(Icons.trending_down_rounded, color: Colors.red),
        //     const SpacerHorizontal(width: 5),

        //     Text(
        //       "Most Bearish",
        //       style: styleGeorgiaBold(fontSize: 17),
        //     ),
        //   ],
        // ),
        // const SpacerVertical(height: 5),
        Text(
          "This segment highlights stocks exhibiting the highest bearish sentiment, determined by predominantly negative news sentiment over the past 7 days, on average.",
          style: stylePTSansRegular(fontSize: 13, color: ThemeColors.greyText),
        ),
        const SpacerVertical(),
        ListView.separated(
          itemCount: data?.mostBearish?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MostBullishData? bearishData = data?.mostBearish![index];
            return MostBullishItem(
              alertForBearish: bearishData?.isAlertAdded ?? 0,
              watlistForBearish: bearishData?.isWatchlistAdded ?? 0,
              data: bearishData!,
              up: false,
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            // return const SpacerVertical(height: 12);
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 12,
            );
          },
        ),
        const SpacerVertical(height: Dimen.itemSpacing),
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
