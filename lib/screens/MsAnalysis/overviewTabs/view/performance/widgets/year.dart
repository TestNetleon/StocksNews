import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widget/pointer_container.dart';
import '../index.dart';
import 'ms_range_bar.dart';
import 'title_subtitle.dart';

class MsPerformanceYear extends StatelessWidget {
  const MsPerformanceYear({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    num weekLow = keyStats?.yearLowValue ?? 0;
    num weekHigh = keyStats?.yearHighValue ?? 0;
    num todayLow = keyStats?.dayLowValue ?? 0;
    num todayHigh = keyStats?.dayHighValue ?? 0;
    num currentPrice = keyStats?.priceValue ?? 0;
    String price = keyStats?.price ?? "";

    // num weekLow = 0;
    // num weekHigh = 100;
    // num todayLow = 50;
    // num todayHigh = 60;
    // num currentPrice = 55;
    // String price = "\$$currentPrice";

    double pointerPosition = (currentPrice - weekLow) / (weekHigh - weekLow);
    pointerPosition = pointerPosition.clamp(0.0, 1.0);

    return Column(
      children: [
        MsPerformanceTitleSubtitle(
          leading: "52 Week Low",
          trailing: "52 Week High",
        ),
        SpacerVertical(height: 8),
        MsPerformanceTitleSubtitle(
          leading: '${keyStats?.yearLow}',
          trailing: '${keyStats?.yearHigh}',
          color: ThemeColors.white,
        ),
        SpacerVertical(height: 10),
        Container(
          height: 70,
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
                color: (keyStats?.changesPercentage ?? 0) >= 0
                    ? ThemeColors.accent
                    : ThemeColors.sos,
              ),
              Positioned(
                left: (msWidthPadding) * pointerPosition - 20,
                top: 12,
                child: MsPointerContainer(
                  style: styleGeorgiaBold(color: ThemeColors.background),
                  title: price,
                  color: (keyStats?.changesPercentage ?? 0) >= 0
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
