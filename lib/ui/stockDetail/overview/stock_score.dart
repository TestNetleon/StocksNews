import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/extra/container.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/stockDetail/overview.dart';

class SDStocksScore extends StatelessWidget {
  final SDStockScoreRes? stockScore;
  const SDStocksScore({
    super.key,
    this.stockScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerVertical(height: Pad.pad24),
          BaseHeading(title: stockScore?.title),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: SDColumnContainer(
                    label: stockScore?.altmanZScore?.title ?? '',
                    value: stockScore?.altmanZScore?.value,
                    padding: EdgeInsets.only(bottom: Pad.pad8, right: Pad.pad8),
                  ),
                ),
                Expanded(
                  child: SDColumnContainer(
                    label: stockScore?.piotroskiScore?.title ?? '',
                    value: stockScore?.piotroskiScore?.value,
                    padding: EdgeInsets.only(bottom: Pad.pad8),
                  ),
                ),
              ],
            ),
          ),
          SDRowContainer(
            label: stockScore?.mostRepeatedGrade?.title ?? '',
            value: stockScore?.mostRepeatedGrade?.value,
            padding: EdgeInsets.only(bottom: Pad.pad8, right: Pad.pad8),
            showArrow: false,
          ),
        ],
      ),
    );
  }
}
