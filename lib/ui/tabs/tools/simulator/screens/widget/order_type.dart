import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class TradingOrderType extends StatelessWidget {
  final String? tradeType;
  const TradingOrderType({
    super.key,
    this.tradeType,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: tradeType != null && tradeType != '',
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(vertical: Pad.pad10, horizontal: Pad.pad10),
        margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
        decoration: BoxDecoration(
          color: tradeType == 'Buy to Cover'
              ? ThemeColors.success120.withValues(alpha: 1.7)
              : ThemeColors.error120.withValues(alpha: 1.7),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Order Type',
                style: styleBaseBold(
                  fontSize: 12,
                  color: ThemeColors.splashBG,
                ),
              ),
            ),
            Flexible(
              child: Text(
                tradeType ?? '',
                style: styleBaseBold(
                  fontSize: 12,
                  color: ThemeColors.splashBG,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
