import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../models/ai_analysis.dart';
import '../../../../../../utils/theme.dart';
import '../index.dart';
import 'container.dart';

class AIPerformanceToday extends StatelessWidget {
  const AIPerformanceToday({super.key});

  @override
  Widget build(BuildContext context) {
    // MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    AIManager manager = context.watch<AIManager>();
    AIPerformanceRes? topData = manager.data?.performance;
    if (topData == null) {
      return SizedBox();
    }
    num todayLow = topData.dayLow ?? 0;
    num todayHigh = topData.dayHigh ?? 0;
    num currentPrice = topData.price ?? 0;
    String price = '${topData.price?.toFormattedPrice()}';

    // num todayLow = 0;
    // num todayHigh = 100;
    // num currentPrice = 0;
    // String price = "\$$currentPrice";

    num priceRange = todayHigh - todayLow;
    double pricePosition =
        ((currentPrice - todayLow) / priceRange).clamp(0.0, 1.0) * 100;

    return Column(
      children: [
        SpacerVertical(height: 30),
        SizedBox(
          // height: 70,
          child: Stack(
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 28, bottom: 10),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(30),
                  minHeight: 8,
                  value: 1,
                  color:
                      (manager.data?.tickerDetail?.changesPercentage ?? 0) >= 0
                          ? ThemeColors.accent
                          : ThemeColors.sos,
                ),
              ),
              Positioned(
                top: 0,
                left: (pricePosition * (msWidthPadding - 60) / 100) + 10,
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
                    todayLow.toFormattedPrice(),
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
                    todayHigh.toFormattedPrice(),
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
