import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MostBearish extends StatelessWidget {
  const MostBearish({super.key});
//
  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();

    TrendingRes? data = provider.mostBearish;
    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Trending - Most Bearish"},
    );

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
        Visibility(
          visible: provider.mostBullish?.text?.mostBullish != '',
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.sp),
            child: Text(
              provider.mostBullish?.text?.mostBullish ?? "",
              style:
                  stylePTSansRegular(fontSize: 13, color: ThemeColors.greyText),
            ),
          ),
        ),
        ListView.separated(
          itemCount: data?.mostBearish?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MostBullishData? bearishData = data?.mostBearish![index];
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      const SpacerHorizontal(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          maxLines: 1,
                          "COMPANY",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Expanded(
                        // flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              maxLines: 1,
                              "PRICE",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                            AutoSizeText(
                              maxLines: 1,
                              "(% Change)",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerHorizontal(width: 15),
                      Column(
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            "MENTIONS",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            "(% Change)",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ],
                      ),
                      const SpacerHorizontal(width: 10),
                    ],
                  ),
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                    thickness: 1,
                  ),
                  MostBullishItem(
                    alertForBearish: bearishData?.isAlertAdded ?? 0,
                    watlistForBearish: bearishData?.isWatchlistAdded ?? 0,
                    data: bearishData!,
                    up: false,
                    index: index,
                  ),
                ],
              );
            }

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
