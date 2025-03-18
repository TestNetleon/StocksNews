import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../../models/stockDetail/price_volume.dart';

class AIPricePostVolume extends StatelessWidget {
  const AIPricePostVolume({super.key});

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    AIPriceVolumeRes? data = manager.dataPV;

    return ListView.builder(
      itemCount: data?.data?.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        BaseKeyValueRes? item = data?.data?[index];

        return AIPricePostVolumeItem(data: item);
      },
    );
  }
}

class AIPricePostVolumeItem extends StatelessWidget {
  final BaseKeyValueRes? data;

  const AIPricePostVolumeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double rawValue = data?.value ?? 0;
    double percentage = (rawValue.abs().clamp(0, 100) / 100);

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
            "${data?.title}",
            style: styleBaseRegular(
              fontSize: 14,
              color: ThemeColors.neutral80,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            // child: LinearBarCommon(value: percentage),
            child: LinearPercentIndicator(
              animation: true,
              animationDuration: 1000,
              lineHeight: 12,
              percent: percentage,
              center: Text(
                "${rawValue < 0 ? '-' : ''}${rawValue.abs().toStringAsFixed(1)}%",
                style: styleBaseBold(
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
