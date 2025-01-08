import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../tradingSimulator/modals/trading_search_res.dart';
import '../../provider/trades.dart';

class TournamentTradeItem extends StatelessWidget {
  final TradingSearchTickerRes? data;
  const TournamentTradeItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.pop(context, data),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: CachedNetworkImage(
                width: 43,
                height: 43,
                imageUrl: data?.image ?? '',
              ),
            ),
            SpacerHorizontal(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.symbol ?? '',
                    style: styleGeorgiaBold(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        data?.name ?? '',
                        style: styleGeorgiaRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: ThemeColors.greyBorder,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "${data?.change ?? 0} %",
                style: styleGeorgiaRegular(
                  fontSize: 13,
                  color: (data?.changesPercentage ?? 0) < 0
                      ? ThemeColors.sos
                      : ThemeColors.accent,
                ),
              ),
            ),
            SpacerHorizontal(width: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data?.status == 1
                    ? ThemeColors.greyBorder
                    : data?.type == StockType.sell
                        ? ThemeColors.sos
                        : ThemeColors.accent,
              ),
              padding: EdgeInsets.all(10),
            )
          ],
        ),
      ),
    );
  }
}
