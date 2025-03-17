import 'package:flutter/material.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../models/stockDetail/overview.dart';

class TechnicalAnaItemAverages extends StatelessWidget {
  final BaseKeyValueRes data;
  const TechnicalAnaItemAverages({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String simpleStatus = data.simpleStatus ?? '-';
    String expoStatus = data.exponentialStatus ?? '-';
    String weightedStatus = data.weightedStatus ?? '-';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad10),
      child: Row(
        children: [
          Visibility(
            visible: data.title != null && data.title != '',
            child: Expanded(
              child: Text(
                '${data.title}',
                // style: styleBaseRegular(fontSize: 14),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Visibility(
            visible: data.simple != null && data.simple != '',
            child: Expanded(
              child: _columnWidget(
                top: data.simple ?? '',
                bottom: simpleStatus,
                crossAxisAlignment: CrossAxisAlignment.start,
                bottomColor: simpleStatus.contains('Sell')
                    ? ThemeColors.error120
                    : simpleStatus.contains('Buy')
                        ? ThemeColors.success120
                        : ThemeColors.black,
              ),
            ),
          ),
          Visibility(
            visible: data.exponential != null && data.exponential != '',
            child: Expanded(
              child: _columnWidget(
                top: data.exponential ?? '',
                bottom: expoStatus,
                crossAxisAlignment: CrossAxisAlignment.start,
                bottomColor: expoStatus.contains('Sell')
                    ? ThemeColors.error120
                    : expoStatus.contains('Buy')
                        ? ThemeColors.success120
                        : ThemeColors.black,
              ),
            ),
          ),
          Visibility(
            visible: data.weighted != null && data.weighted != '',
            child: Expanded(
              child: _columnWidget(
                top: data.weighted ?? '',
                bottom: weightedStatus,
                crossAxisAlignment: CrossAxisAlignment.start,
                bottomColor: weightedStatus.contains('Sell')
                    ? ThemeColors.error120
                    : weightedStatus.contains('Buy')
                        ? ThemeColors.success120
                        : ThemeColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _columnWidget({
    required String top,
    required String bottom,
    Color? bottomColor,
    TextAlign? textAlign = TextAlign.end,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            textAlign: textAlign,
            top,
            // style: styleBaseBold(fontSize: 14),
            style: Theme.of(navigatorKey.currentContext!).textTheme.bodySmall,
          ),
          Text(
            textAlign: textAlign,
            bottom,
            style: styleBaseBold(
              fontSize: 14,
              color: bottomColor,
            ),
          ),
        ],
      ),
    );
  }
}
