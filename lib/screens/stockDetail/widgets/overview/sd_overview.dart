import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/range.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'desclaimer.dart';
import 'top_widget.dart';

class SdOverview extends StatelessWidget {
  const SdOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: Column(
          children: [
            SdTopWidgetDetail(),
            SpacerVertical(height: 4),
            SdTopDisclaimer(),
            SpacerVertical(height: 4),
            SdTopWidgetRange(),
          ],
        ),
      ),
    );
  }
}
