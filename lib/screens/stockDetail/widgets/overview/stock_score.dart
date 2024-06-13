import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/overview.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../stockDetails/widgets/states.dart';

class SdStockScore extends StatelessWidget {
  const SdStockScore({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    StockScore? score = provider.overviewRes?.stockScore;
    return Column(
      children: [
        ScreenTitle(
          title: 'Stock Score/grades',
          subTitle: provider.overviewRes?.stockScore?.text,
        ),
        StateItem(label: "Altman Z Score ", value: score?.altmanZScore),
        StateItem(label: "Piotroski Score", value: score?.piotroskiScore),
        StateItem(label: "Grade", value: score?.mostRepeatedGrade),
        const SpacerVertical(height: 20),
      ],
    );
  }
}
