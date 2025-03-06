import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../models/ai_analysis.dart';

class AIPerformanceFooter extends StatelessWidget {
  const AIPerformanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    AIManager manager = context.watch<AIManager>();
    AIPerformanceRes? topData = manager.data?.performance;

    return Container(
      decoration: const BoxDecoration(),
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _widget(
              label: 'Open Price',
              value: '${topData?.price}',
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            _widget(
              label: 'Prev. Close',
              value: '${topData?.previousClose}',
            ),
            _widget(
              label: 'Volume',
              value: '${topData?.volume}',
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _widget({
    required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Flexible(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            label,
            style: styleBaseRegular(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          SpacerVertical(height: 4),
          Text(
            value,
            style: styleBaseBold(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
