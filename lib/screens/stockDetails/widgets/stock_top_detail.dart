import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'stockTopWidgets/desclaimer.dart';
import 'stockTopWidgets/detail.dart';
import 'stockTopWidgets/range.dart';

class StockTopDetail extends StatelessWidget {
  const StockTopDetail({super.key});
//
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StockDetailTopWidgetDetail(),
        SpacerVertical(height: 4),
        StockDetailTopDisclaimer(),
        SpacerVertical(height: 10),
        StockDetailTopWidgetRange(),
      ],
    );
  }
}
