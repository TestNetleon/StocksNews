import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../models/stockDetail/overview.dart';

class TechnicalAnaItemIndicator extends StatelessWidget {
  final BaseKeyValueRes data;
  const TechnicalAnaItemIndicator({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String action = data.action ?? '';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad10),
      child: Row(
        children: [
          Visibility(
            visible: data.title != null && data.title != '',
            child: Expanded(
              child: Text(
                '${data.title}',
                style: styleBaseRegular(fontSize: 14),
              ),
            ),
          ),
          Visibility(
            visible: data.value != null && data.value != '',
            child: Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  textAlign: TextAlign.start,
                  '${data.value}',
                  style: styleBaseBold(fontSize: 14),
                ),
              ),
            ),
          ),
          Visibility(
            visible: action != '',
            child: Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  textAlign: TextAlign.start,
                  data.action ?? '-',
                  style: styleBaseBold(
                    fontSize: 14,
                    color: action.contains('Sell')
                        ? ThemeColors.error120
                        : action.contains('Buy')
                            ? ThemeColors.success120
                            : ThemeColors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
