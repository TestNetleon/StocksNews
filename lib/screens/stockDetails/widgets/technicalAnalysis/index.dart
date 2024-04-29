import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'test/container.dart';

class StocksTechnicalAnalysis extends StatelessWidget {
  const StocksTechnicalAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
//
    return Column(
      children: [
        ScreenTitle(
          title: "${provider.data?.keyStats?.symbol} Technical Analysis",
          subTitle:
              "In the Technical Analysis section for this stock, various timeframes, moving averages, and technical indicators offer insights into sentiment trends, helping forecast whether the prevailing sentiment suggests a buy or sell recommendation.",
          // style: stylePTSansRegular(fontSize: 20),
        ),
        provider.tALoading && provider.technicalAnalysisRes == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: ThemeColors.accent,
                  ),
                  const SpacerHorizontal(width: 5),
                  Flexible(
                    child: Text(
                      "Fetching technical analysis data...",
                      style: stylePTSansRegular(color: ThemeColors.accent),
                    ),
                  ),
                ],
              )
            : provider.data != null
                // ? const StocksTechnicalAnalysisBase()

                ? const TEstTechnicalAnalysis()
                : Text(
                    "No technical analysis data found.",
                    style: stylePTSansRegular(),
                  ),
      ],
    );
  }
}
