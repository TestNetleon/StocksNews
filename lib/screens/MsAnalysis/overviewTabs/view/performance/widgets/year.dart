import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../modals/msAnalysis/ms_top_res.dart';
import '../../../../../../providers/stockAnalysis/provider.dart';
import '../../../../widget/pointer_container.dart';
import '../index.dart';
import 'ms_range_bar.dart';
import 'title_subtitle.dart';

class MsPerformanceYear extends StatelessWidget {
  const MsPerformanceYear({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsStockTopRes? topData = provider.topData;

    if (topData == null) {
      return SizedBox();
    }

    num weekLow = topData.yearLowValue ?? 0;
    num weekHigh = topData.yearHighValue ?? 0;
    num todayLow = topData.dayLowValue ?? 0;
    num todayHigh = topData.dayHighValue ?? 0;
    num currentPrice = topData.priceValue ?? 0;
    String price = topData.price ?? "";

    // num weekLow = 0;
    // num weekHigh = 100;
    // num todayLow = 50;
    // num todayHigh = 60;
    // num currentPrice = 0;
    // String price = "\$$currentPrice";

    double pointerPosition = (currentPrice - weekLow) / (weekHigh - weekLow);
    pointerPosition = pointerPosition.clamp(0.0, 1.0);

    double finalPosition = (msWidthPadding) * pointerPosition - 40;

    return Column(
      children: [
        MsPerformanceTitleSubtitle(
          leading: "52 Week Low",
          trailing: "52 Week High",
        ),
        SpacerVertical(height: 8),
        MsPerformanceTitleSubtitle(
          leading: '${topData.yearLow}',
          trailing: '${topData.yearHigh}',
          color: ThemeColors.white,
        ),
        SpacerVertical(height: 10),
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              MsRangeProgressBar(
                weekLow: weekLow,
                weekHigh: weekHigh,
                todayLow: todayLow,
                todayHigh: todayHigh,
                currentPrice: currentPrice,
                color: (topData.changesPercentage ?? 0) >= 0
                    ? ThemeColors.accent
                    : ThemeColors.sos,
              ),
              Positioned(
                left: finalPosition <= 0 ? 10 : finalPosition - 5,
                top: 12,
                child: MsPointerContainer(
                  style: styleGeorgiaBold(
                      color: ThemeColors.background, fontSize: 12),
                  title: price,
                  color: (topData.changesPercentage ?? 0) >= 0
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import '../../../../../../modals/msAnalysis/ms_top_res.dart';
// import '../../../../../../providers/stockAnalysis/provider.dart';
// import '../../../../widget/pointer_container.dart';
// import 'title_subtitle.dart';

// class MsPerformanceYear extends StatelessWidget {
//   const MsPerformanceYear({super.key});
//   @override
//   Widget build(BuildContext context) {
//     MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
//     MsStockTopRes? topData = provider.topData;

//     if (topData == null) {
//       return SizedBox();
//     }

//     // num weekLow = topData.yearLowValue ?? 0;
//     // num weekHigh = topData.yearHighValue ?? 100;
//     // num todayLow = topData.dayLowValue ?? 50;
//     // num todayHigh = topData.dayHighValue ?? 60;
//     // num currentPrice = topData.priceValue ?? 50;
//     // String price = "\$$currentPrice";

//     num weekLow = 0;
//     num weekHigh = 100;
//     num todayLow = 50;
//     num todayHigh = 60;
//     num currentPrice = 0;
//     String price = "\$$currentPrice";

//     double scale = 300 / (weekHigh - weekLow);

//     double todayLowPosition = (todayLow - weekLow) * scale;
//     double todayHighPosition = (todayHigh - weekLow) * scale;
//     double todayWidth = todayHighPosition - todayLowPosition;

//     double currentPricePosition = (currentPrice - weekLow) * scale;

//     return Column(
//       children: [
//         MsPerformanceTitleSubtitle(
//           leading: "52 Week Low",
//           trailing: "52 Week High",
//         ),
//         SpacerVertical(height: 8),
//         MsPerformanceTitleSubtitle(
//           leading: '${topData.yearLow}',
//           trailing: '${topData.yearHigh}',
//           color: ThemeColors.white,
//         ),
//         SpacerVertical(height: 10),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Container(
//             alignment: Alignment.center,
//             child: Stack(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   height: 50,
//                   child: Stack(
//                     children: [
//                       Container(
//                         // width: 300,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                       Container(
//                         height: 8,
//                         width: todayWidth,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: ThemeColors.sos,
//                         ),
//                         margin: EdgeInsets.only(left: todayLowPosition),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: currentPricePosition,
//                   top: 10,
//                   child: MsPointerContainerNew(
//                     title: price,
//                     color: ThemeColors.sos,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
