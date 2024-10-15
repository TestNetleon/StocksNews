import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../../modals/msAnalysis/ms_top_res.dart';

class MsPerformanceFooter extends StatelessWidget {
  const MsPerformanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsStockTopRes? topData = provider.topData;

    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 36, 32, 32),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _widget(
              label: 'Open Price',
              value: '${topData?.price}',
            ),
            SizedBox(
              height: 30,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            _widget(
              label: 'Prev. Close',
              value: '${provider.completeData?.previousClose}',
            ),
            SizedBox(
              height: 30,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 2,
                // indent: 3/
              ),
            ),
            _widget(
              label: 'Volume',
              value: '${provider.completeData?.volume}',
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
            style: styleGeorgiaBold(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          SpacerVertical(height: 8.0),
          Text(
            value,
            style: stylePTSansRegular(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
