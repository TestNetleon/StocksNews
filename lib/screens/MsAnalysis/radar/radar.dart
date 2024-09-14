import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import 'chart.dart';

class MsRadarGraph extends StatefulWidget {
  const MsRadarGraph({super.key});

  @override
  State<MsRadarGraph> createState() => _MsRadarGraphState();
}

class _MsRadarGraphState extends State<MsRadarGraph> {
  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return BaseUiContainer(
      isLoading: provider.isLoadingRadar,
      hasData: !provider.isLoadingRadar &&
          provider.radar != null &&
          provider.radar?.isNotEmpty == true,
      showPreparingText: true,
      hideWidget: true,
      placeholder: SizedBox(
        height: 450,
        width: double.infinity,
        child: Loading(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MsRadarChartView(data: provider.radar),
          SpacerVertical(height: 10),
          Visibility(
            visible: provider.extra?.recommendation != null &&
                provider.extra?.recommendation != '',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Stocks.News Verdict",
                  style: styleSansBold(
                    color: ThemeColors.white,
                    fontSize: 20,
                  ),
                ),
                SpacerHorizontal(width: 20),
                Text(
                  "${provider.extra?.recommendation}",
                  style: stylePTSansRegular(
                    fontSize: 70,
                    color: ThemeColors.accent,
                    fontFamily: Fonts.merriWeather,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
