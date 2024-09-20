import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../../../modals/msAnalysis/radar_chart.dart';
import '../../../../../../providers/stockAnalysis/provider.dart';

class MsPricePostVolume extends StatelessWidget {
  const MsPricePostVolume({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    // List<Map<String, dynamic>> postVolume = [
    //   {
    //     "title": "Prev Day",
    //     "amount": "10.0%",
    //   },
    //   {
    //     "title": "1 week avg",
    //     "amount": "41.4%",
    //   },
    //   {"title": "1 month avg", "amount": "39.7%"},
    //   {"title": "3 months avg", "amount": "26.4%"},
    //   {"title": "1 year avg", "amount": "50.67%"},
    // ];

    // double _parsePercentage(String percentage) {
    //   final cleanedPercentage = percentage.replaceAll('%', '');
    //   return double.tryParse(cleanedPercentage)! / 100;
    // }
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return Column(
      children: [
        ListView.builder(
          itemCount: provider.pvData?.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            MsRadarChartRes? item = provider.pvData?[index];

            return MsPricePostVolumeItem(data: item);
          },
        ),
      ],
    );
  }
}

class MsPricePostVolumeItem extends StatelessWidget {
  final MsRadarChartRes? data;

  const MsPricePostVolumeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Get the raw value and ensure it's clamped to a valid range for the indicator
    double rawValue = data?.value ?? 0;
    double percentage = (rawValue.abs().clamp(0, 100) /
        100); // Use absolute value for the indicator

    Color getProgressColor(double percent) {
      if (percent < 0.33) {
        return Colors.red;
      } else if (percent < 0.66) {
        return Colors.orange;
      } else {
        return Colors.green;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            textAlign: TextAlign.start,
            "${data?.label}",
            style: stylePTSansRegular(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LinearPercentIndicator(
              animation: true,
              animationDuration: 1000,
              lineHeight: 12,
              percent: percentage,
              center: Text(
                "${rawValue < 0 ? '-' : ''}${rawValue.abs().toStringAsFixed(1)}%", // Show negative sign if value is negative
                style: stylePTSansBold(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              progressColor: getProgressColor(percentage),
            ),
          ),
        ),
      ],
    );
  }
}
