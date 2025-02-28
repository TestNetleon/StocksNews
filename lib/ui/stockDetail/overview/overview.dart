import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../models/stockDetail/overview.dart';
import 'chart.dart';
import 'range.dart';

class StocksDetailOverview extends StatelessWidget {
  const StocksDetailOverview({super.key});

  @override
  Widget build(BuildContext context) {
    StocksDetailManager manager = context.watch<StocksDetailManager>();
    StocksTickerDataRes? tickerData = manager.dataOverview?.tickerData;
    bool hideRange = tickerData?.dayHigh == null ||
        tickerData?.dayLow == null ||
        tickerData?.yearHigh == null ||
        tickerData?.yearLow == null;

    return Column(
      children: [
        //Range
        Visibility(
          visible: !hideRange,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: Row(
              children: [
                Expanded(
                  child: StocksDetailRange(
                    title: 'Day’s Range',
                    endString: tickerData?.dayHigh?.toFormattedPrice() ?? '',
                    endValue: tickerData?.dayHigh ?? 0,
                    startString: tickerData?.dayLow?.toFormattedPrice() ?? '',
                    startValue: tickerData?.dayLow ?? 0,
                    mainValue: tickerData?.currentPrice ?? 0,
                  ),
                ),
                SpacerHorizontal(width: 10),
                Expanded(
                  child: StocksDetailRange(
                    title: '',
                    endString: tickerData?.yearHigh?.toFormattedPrice() ?? '',
                    endValue: tickerData?.yearHigh ?? 0,
                    startString: tickerData?.yearLow?.toFormattedPrice() ?? '',
                    startValue: tickerData?.yearLow ?? 0,
                    mainValue: tickerData?.currentPrice ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        //Historical Chart
        StocksDetailHistoricalChart(),
      ],
    );
  }
}
