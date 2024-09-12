import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../../modals/msAnalysis/radar_chart.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class MsRadarChartView extends StatelessWidget {
  final List<MsRadarChartRes>? data;
  const MsRadarChartView({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              text: (data?[index].label?.toUpperCase()) ?? "N/A",
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
                data?.length ?? 0,
                (index) {
                  return fl.RadarEntry(
                      value: data?[index].value?.toDouble() ?? 0);
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
    );
  }
}
