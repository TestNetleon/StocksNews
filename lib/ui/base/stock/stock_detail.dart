import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../utils/colors.dart';

class BaseStockDetailHeader extends StatelessWidget {
  final BaseTickerRes data;
  const BaseStockDetailHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.displayPrice ?? '',
                  // style: styleBaseBold(fontSize: 28),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Visibility(
                  visible: data.displayChange != null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        if (data.changesPercentage != null)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Image.asset(
                                (data.changesPercentage ?? 0) >= 0
                                    ? Images.trendingUP
                                    : Images.trendingDOWN,
                                height: 18,
                                width: 18,
                                color: (data.changesPercentage ?? 0) >= 0
                                    ? ThemeColors.accent
                                    : ThemeColors.sos,
                              ),
                            ),
                          ),
                        TextSpan(
                          text: data.displayChange,
                          style: styleBaseSemiBold(
                            fontSize: 13,
                            color: (data.changesPercentage ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                        if (data.changesPercentage != null)
                          TextSpan(
                            text: ' (${data.changesPercentage}%)',
                            style: styleBaseSemiBold(
                              fontSize: 13,
                              color: (data.changesPercentage ?? 0) >= 0
                                  ? ThemeColors.accent
                                  : ThemeColors.sos,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Closed ${data.closeDate}',
                  style: styleBaseRegular(
                      fontSize: 13, color: ThemeColors.neutral40),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.mktCap ?? '',
                  // style: styleBaseBold(fontSize: 28),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'MKT Cap',
                  style: styleBaseRegular(
                    fontSize: 14,
                    color: ThemeColors.neutral40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
