import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/stockTopWidgets/range.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import 'stockTopWidgets/desclaimer.dart';
import 'stockTopWidgets/detail.dart';

class StockTopDetail extends StatelessWidget {
  const StockTopDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StockDetailTopWidgetDetail(),
        SpacerVerticel(height: 4),
        StockDetailTopDisclaimer(),
        SpacerVerticel(height: 10),
        StockDetailTopWidgetRange(),
      ],
    );
  }
}
