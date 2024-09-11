// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stock_details_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import '../../../../../../utils/theme.dart';
// import '../../../../widget/pointer_container.dart';
// import '../index.dart';
// import 'title_subtitle.dart';

// class MsPerformanceToday extends StatelessWidget {
//   const MsPerformanceToday({super.key});

//   double _calculatePointerPosition(
//     num dayLow,
//     num dayHigh,
//     num price,
//   ) {
//     if (dayHigh == dayLow) {
//       return 0.0;
//     }

//     double progress = (price - dayLow) / (dayHigh - dayLow);
//     double position = msWidthPadding * progress;

//     position = position.clamp(0.0, msWidthPadding);

//     return position;
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     KeyStats? keyStats = provider.tabRes?.keyStats;

//     // num todayLow = keyStats?.dayLowValue ?? 0;
//     // num todayHigh = keyStats?.dayHighValue ?? 0;
//     // num currentPrice = keyStats?.priceValue ?? 0;

//     // String price = keyStats?.price ?? "";

//     num todayLow = 0;
//     num todayHigh = 100;
//     num currentPrice = 50;
//     String price = "\$$currentPrice";

//     double pointerPosition = _calculatePointerPosition(
//       todayLow,
//       todayHigh,
//       currentPrice,
//     );
//     Utils().showLog('Pointer Position: $pointerPosition');
//     return Column(
//       children: [
//         MsPerformanceTitleSubtitle(
//           leading: "Today's Low",
//           trailing: "Today's High",
//         ),
//         SpacerVertical(height: 8),
//         MsPerformanceTitleSubtitle(
//           leading: '${keyStats?.dayLow}',
//           trailing: '${keyStats?.dayHigh}',
//           color: ThemeColors.white,
//         ),
//         SpacerVertical(height: 10),
//         SizedBox(
//           height: 70,
//           child: Stack(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20),
//                 width: msWidthPadding,
//                 child: LinearProgressIndicator(
//                   borderRadius: BorderRadius.circular(30),
//                   minHeight: 8,
//                   value: 1,
//                   color: (keyStats?.changesPercentage ?? 0) >= 0
//                       ? ThemeColors.accent
//                       : ThemeColors.sos,
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 left: pointerPosition - (80 / 2),
//                 child: MsPointerContainer(
//                   style: styleGeorgiaBold(color: ThemeColors.background),
//                   title: price,
//                   color: (keyStats?.changesPercentage ?? 0) >= 0
//                       ? ThemeColors.accent
//                       : ThemeColors.sos,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../modals/msAnalysis/ms_top_res.dart';
import '../../../../../../providers/stockAnalysis/provider.dart';
import '../../../../../../utils/theme.dart';
import '../../../../widget/pointer_container.dart';
import '../index.dart';
import 'title_subtitle.dart';

class MsPerformanceToday extends StatelessWidget {
  const MsPerformanceToday({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsStockTopRes? topData = provider.topData;
    num todayLow = topData?.dayLowValue ?? 0;
    num todayHigh = topData?.dayHighValue ?? 0;
    num currentPrice = topData?.priceValue ?? 0;
    String price = "\$$currentPrice";

    // num todayLow = 0;
    // num todayHigh = 100;
    // num currentPrice = 50;
    // String price = "\$$currentPrice";

    double pricePosition =
        (currentPrice - todayLow) / (todayHigh - todayLow) * msWidthPadding;

    Utils().showLog("$pricePosition");
    return Column(
      children: [
        MsPerformanceTitleSubtitle(
          leading: "Today's Low",
          trailing: "Today's High",
        ),
        SpacerVertical(height: 8),
        MsPerformanceTitleSubtitle(
          leading: '${topData?.dayLow}',
          trailing: '${topData?.dayHigh}',
          color: ThemeColors.white,
        ),
        SpacerVertical(height: 10),
        SizedBox(
          height: 70,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: msWidthPadding,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(30),
                  minHeight: 8,
                  value: 1,
                  color: (topData?.changesPercentage ?? 0) >= 0
                      ? ThemeColors.accent
                      : ThemeColors.sos,
                ),
              ),
              Positioned(
                top: 12,
                left: pricePosition - (currentPrice == todayLow ? 20 : 40),
                child: MsPointerContainer(
                  style: styleGeorgiaBold(color: ThemeColors.background),
                  title: price,
                  color: (topData?.changesPercentage ?? 0) >= 0
                      ? ThemeColors.accent
                      : ThemeColors.sos,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
