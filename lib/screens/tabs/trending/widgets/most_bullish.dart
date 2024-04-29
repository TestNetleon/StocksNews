import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class MostBullish extends StatelessWidget {
  const MostBullish({super.key});

  @override
  Widget build(BuildContext context) {
    // TrendingProvider provider = context.watch<TrendingProvider>();
    TrendingRes? data = context.watch<TrendingProvider>().mostBullish;
//
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // ColoredText(
            //   text: "Most Bullish",
            //   coloredLetters: const ["B"],
            //   style: stylePTSansBold(),
            // ),

            const Icon(
              Icons.trending_up_rounded,
              color: ThemeColors.accent,
            ),
            const SpacerHorizontal(width: 5),
            Text(
              "Most Bullish",
              style: styleGeorgiaBold(fontSize: 17),
            ),
          ],
        ),
        const SpacerVerticel(height: 5),
        Text(
          "This segment displays stocks with the most bullish outlook, determined by a consistently positive (bullish) sentiment in recent news over the past 7 days.",
          style: stylePTSansRegular(fontSize: 12),
        ),
        const SpacerVerticel(),
        ListView.separated(
          itemCount: data?.mostBullish?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MostBullishData? bullishData = data?.mostBullish![index];
            return MostBullishItem(
              alertForBullish: bullishData?.isAlertAdded ?? 0,
              watlistForBullish: bullishData?.isWatchlistAdded ?? 0,
              data: bullishData!,
              up: true,
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SpacerVerticel(height: 12);
          },
        ),
        const SpacerVerticel(height: Dimen.itemSpacing),
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
