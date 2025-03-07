import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../widgets/spacer_vertical.dart';

class MostBullish extends StatelessWidget {
  const MostBullish({super.key});

  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();
    TrendingRes? data = provider.mostBullish;

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Trending - Most Bullish"},
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: data?.text?.mostBullish != '',
          child: Padding(
              padding: EdgeInsets.only(bottom: isPhone ? 5 : 5.sp),
              child: CustomReadMoreText(
                text: data?.text?.mostBullish ?? "",
              )
              //  Text(
              //   data?.text?.mostBullish ?? "",
              //   style: stylePTSansRegular(
              //     fontSize: 13,
              //     color: ThemeColors.greyText,
              //   ),
              // ),
              ),
        ),
        SlidableAutoCloseBehavior(
          child: ListView.separated(
            itemCount: data?.mostBullish?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              MostBullishData? bullishData = data?.mostBullish![index];
              // if (index == 0) {
              //   return Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Divider(
              //         color: ThemeColors.greyBorder,
              //         height: 15.sp,
              //         thickness: 1,
              //       ),
              //       Row(
              //         children: [
              //           const SpacerHorizontal(width: 5),
              //           Expanded(
              //             child: AutoSizeText(
              //               maxLines: 1,
              //               "COMPANY",
              //               style: stylePTSansRegular(
              //                 fontSize: 12,
              //                 color: ThemeColors.greyText,
              //               ),
              //             ),
              //           ),
              //           // const SpacerHorizontal(width: 24),
              //           const SpacerHorizontal(width: 10),
              //           Expanded(
              //             // flex: 3,
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 AutoSizeText(
              //                   maxLines: 1,
              //                   "PRICE",
              //                   style: stylePTSansRegular(
              //                     fontSize: 12,
              //                     color: ThemeColors.greyText,
              //                   ),
              //                 ),
              //                 AutoSizeText(
              //                   maxLines: 1,
              //                   "(% Change)",
              //                   style: stylePTSansRegular(
              //                     fontSize: 12,
              //                     color: ThemeColors.greyText,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Column(
              //             children: [
              //               AutoSizeText(
              //                 maxLines: 1,
              //                 "MENTIONS",
              //                 textAlign: TextAlign.end,
              //                 style: stylePTSansRegular(
              //                   fontSize: 12,
              //                   color: ThemeColors.greyText,
              //                 ),
              //               ),
              //               AutoSizeText(
              //                 maxLines: 1,
              //                 "(% Change)",
              //                 textAlign: TextAlign.end,
              //                 style: stylePTSansRegular(
              //                   fontSize: 12,
              //                   color: ThemeColors.greyText,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SpacerHorizontal(width: 10),
              //         ],
              //       ),
              //       Divider(
              //         color: ThemeColors.greyBorder,
              //         height: 15.sp,
              //         thickness: 1,
              //       ),
              //       MostBullishItem(
              //         alertForBullish: bullishData?.isAlertAdded ?? 0,
              //         watlistForBullish: bullishData?.isWatchlistAdded ?? 0,
              //         data: bullishData!,
              //         up: true,
              //         index: index,
              //       ),
              //     ],
              //   );
              // }

              return MostBullishItem(
                alertForBullish: bullishData?.isAlertAdded ?? 0,
                watlistForBullish: bullishData?.isWatchlistAdded ?? 0,
                data: bullishData!,
                up: true,
                index: index,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SpacerVertical(height: 12);
              // return const Divider(
              //   color: ThemeColors.greyBorder,
              //   height: 12,
              // );
            },
          ),
        ),
        const SpacerVertical(height: Dimen.itemSpacing),
        if (provider.extra?.disclaimer != null &&
            (!provider.isLoadingBullish &&
                (provider.mostBullish?.mostBullish != null &&
                    provider.mostBullish?.mostBullish?.isNotEmpty == true)))
          DisclaimerWidget(
            data: provider.extra!.disclaimer!,
          ),
      ],
    );
  }
}
