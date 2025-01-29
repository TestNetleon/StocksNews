// ignore_for_file: file_names

import 'package:flutter/widgets.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';

class TradingOrderTypeContainer extends StatelessWidget {
  final String? tradeType;
  const TradingOrderTypeContainer({
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
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: tradeType == 'Buy to Cover'
              ? ThemeColors.darkGreen
              : ThemeColors.sos,
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
                style: styleSansBold(
                  fontSize: 14,
                  color: ThemeColors.white,
                ),
              ),
            ),
            Flexible(
              child: Text(
                tradeType ?? '',
                style: styleSansBold(
                  fontSize: 14,
                  color: ThemeColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
