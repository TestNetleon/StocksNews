import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../../models/ai_analysis.dart';
import '../index.dart';
import 'container.dart';
import 'ms_range_bar.dart';

class AIPerformanceYear extends StatelessWidget {
  const AIPerformanceYear({super.key});

  @override
  Widget build(BuildContext context) {
    // MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    AIManager manager = context.watch<AIManager>();

    AIPerformanceRes? topData = manager.data?.performance;

    if (topData == null) {
      return SizedBox();
    }

    num weekLow = topData.yearLow ?? 0;
    num weekHigh = topData.yearHigh ?? 0;
    num todayLow = topData.dayLow ?? 0;
    num todayHigh = topData.dayHigh ?? 0;
    num currentPrice = topData.price ?? 0;
    String price = '${topData.price?.toFormattedPrice()}';

    // num weekLow = 0;
    // num weekHigh = 100;
    // num todayLow = 50;
    // num todayHigh = 60;
    // num currentPrice = 0;
    // String price = "\$$currentPrice";

    double pointerPosition = (currentPrice - weekLow) / (weekHigh - weekLow);
    pointerPosition = pointerPosition.clamp(0.0, 1.0);

    double finalPosition = (msWidthPadding) * pointerPosition - 55;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: AIRangeProgressBar(
                  weekLow: weekLow,
                  weekHigh: weekHigh,
                  todayLow: todayLow,
                  todayHigh: todayHigh,
                  currentPrice: currentPrice,
                  color:
                      (manager.data?.tickerDetail?.changesPercentage ?? 0) >= 0
                          ? ThemeColors.accent
                          : ThemeColors.sos,
                ),
              ),
              Positioned(
                left: finalPosition <= 0 ? 10 : finalPosition - 5,
                top: 0,
                child: AIPointerContainer(
                  isDownwards: true,
                  style: styleBaseBold(
                      color: ThemeColors.background, fontSize: 12),
                  title: price,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weekLow.toFormattedPrice(),
                    style: styleBaseBold(fontSize: 14),
                  ),
                  Text(
                    '52 Week Low',
                    style: styleBaseRegular(
                      fontSize: 13,
                      color: ThemeColors.neutral80,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    weekHigh.toFormattedPrice(),
                    style: styleBaseBold(fontSize: 14),
                  ),
                  Text(
                    '52 Week High',
                    style: styleBaseRegular(
                      fontSize: 13,
                      color: ThemeColors.neutral80,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
