import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../stockScore/score.dart';

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
        _radarChart(provider),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: MsStockScore(),
        ),
      ],
    );
  }

  Widget _radarChart(MSAnalysisProvider provider) {
    if (provider.isLoadingRadar) {
      return SizedBox(
        height: 350,
        width: double.infinity,
        child: Loading(),
      );
    }
    if (!provider.isLoadingRadar &&
        (provider.radar == null || provider.radar?.isEmpty == true)) {
      return SizedBox();
    }
    return Visibility(
      visible: provider.radar != null && provider.radar?.isNotEmpty == true,
      child: SizedBox(
        height: 350,
        child: fl.RadarChart(
          fl.RadarChartData(
            radarTouchData: fl.RadarTouchData(
              enabled: false,
              touchCallback: (event, response) {
                // Utils()
                //     .showLog("Direction -> ${event.localPosition?.direction}");
                // Utils().showLog("Distance -> ${event.localPosition?.distance}");
                // Utils().showLog(
                //     "Distance Squared -> ${event.localPosition?.distanceSquared}");
                // Utils().showLog("DX -> ${event.localPosition?.dx}");
                // Utils().showLog("DY -> ${event.localPosition?.dy}");
              },
            ),
            titlePositionPercentageOffset: 0.05,
            getTitle: (index, angle) {
              return fl.RadarChartTitle(
                text: (provider.radar?[index].label?.toUpperCase()) ?? "N/A",
                angle: angle,
              );
            },
            titleTextStyle: styleSansBold(color: ThemeColors.white),
            dataSets: [
              fl.RadarDataSet(
                fillColor: Colors.orange.withOpacity(0.8),
                borderColor: Colors.orange,
                borderWidth: 3,
                entryRadius: 0,
                dataEntries: List.generate(
                  provider.radar?.length ?? 0,
                  (index) {
                    return fl.RadarEntry(
                        value: provider.radar?[index].value?.toDouble() ?? 0);
                  },
                ),
              ),
            ],
            radarBackgroundColor: Colors.transparent,
            borderData: fl.FlBorderData(show: false),
            radarBorderData: const BorderSide(
              color: ThemeColors.greyBorder,
            ),
            tickCount: 3,
            tickBorderData: BorderSide(
              color: ThemeColors.greyBorder.withOpacity(0.5),
              width: 15,
              style: BorderStyle.solid,
            ),
            ticksTextStyle: const TextStyle(color: Colors.transparent),
            gridBorderData: BorderSide(
              color: ThemeColors.greyBorder.withOpacity(0.5),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
