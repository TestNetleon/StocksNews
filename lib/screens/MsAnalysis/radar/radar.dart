import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MsRadarChartView(data: provider.completeData?.radarChart),
        SpacerVertical(height: 10),
        Visibility(
          visible: provider.completeData?.recommendationNew != null,
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
                provider.completeData?.recommendationNew?.text ?? "",
                style: stylePTSansRegular(
                  fontSize: 70,
                  color: provider.completeData?.recommendationNew?.color
                              ?.toLowerCase() ==
                          'orange'
                      ? Colors.orange
                      : provider.completeData?.recommendationNew?.color
                                  ?.toLowerCase() ==
                              'red'
                          ? ThemeColors.sos
                          : ThemeColors.accent,
                  fontFamily: Fonts.merriWeather,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
