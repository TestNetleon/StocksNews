import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/msAnalysis/radar_chart.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MsPricePastReturns extends StatelessWidget {
  const MsPricePastReturns({super.key});

  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> pastReturns = [
    //   {
    //     "title": "1 week",
    //     "amount": "-5.0%",
    //   },
    //   {
    //     "title": "1 month",
    //     "amount": "3.7%",
    //   },
    //   {"title": "3 months", "amount": "13.9%"},
    //   {"title": "1 year", "amount": "-8.4%"},
    //   {"title": "4 years", "amount": "141.4%"},
    // ];
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return MsPricePastReturnsItem(
          index: index,
          pastReturns: provider.pvData?[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SpacerVertical(height: 0);
      },
      itemCount: provider.pvData?.length ?? 0,
    );
  }
}

class MsPricePastReturnsItem extends StatelessWidget {
  final MsRadarChartRes? pastReturns;
  final int index;
  const MsPricePastReturnsItem({
    super.key,
    required this.pastReturns,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            index % 2 == 0 ? const Color(0xFF2F2F2F) : const Color(0xFF161616),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Text(
              "${pastReturns?.label}",
              textAlign: TextAlign.center,
              style: styleGeorgiaRegular(
                color: ThemeColors.greyText,
                fontSize: 14,
              ),
            ),
          ),
          const SpacerVertical(height: 10),
          Text(
            textAlign: TextAlign.center,
            "${pastReturns?.value}%",
            style: styleGeorgiaBold(
              color: pastReturns?.value >= 0
                  ? ThemeColors.accent
                  : ThemeColors.sos,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
