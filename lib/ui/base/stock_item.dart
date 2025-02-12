import 'package:flutter/material.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/slidable_menu.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BaseStockItem extends StatelessWidget {
  final BaseTickerRes data;
  final int index;
  const BaseStockItem({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // MostBullishProvider provider = context.read<MostBullishProvider>();
    return SlidableMenuWidget(
      alertForBearish: data.isAlertAdded ?? 0,
      watchlistForBullish: data.isWatchlistAdded ?? 0,
      onClickAlert: () {
        // provider.createAlertSend(
        //   alertName: data.symbol ?? "",
        //   symbol: data.symbol ?? "",
        //   companyName: data.name ?? "",
        //   index: index,
        // );
        AlertsWatchlistAction().createAlertSend(
          alertName: "",
          symbol: data.symbol ?? "",
          companyName: data.name ?? "",
          index: index,
          onSuccess: () {},
        );
      },
      onClickWatchlist: () {
        AlertsWatchlistAction().addToWishList(
          symbol: data.symbol ?? "",
          companyName: data.name ?? "",
          index: index,
          onSuccess: () {},
        );
      },
      index: index,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImagesWidget(
                data.image,
                height: 42,
                width: 42,
              ),
            ),
            const SpacerHorizontal(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.symbol ?? '',
                    style: styleBaseBold(fontSize: 22),
                  ),
                  const SpacerVertical(height: 2),
                  Text(
                    data.name ?? '',
                    style: styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.neutral40,
                    ),
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.price ?? '',
                  style: styleBaseBold(fontSize: 22),
                ),
                const SpacerVertical(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.change ?? '',
                      style: styleBaseSemiBold(
                        fontSize: 14,
                        color: num.parse("${data.changesPercentage ?? 0}") < 0
                            ? ThemeColors.darkRed
                            : ThemeColors.darkGreen,
                      ),
                    ),
                    const SpacerHorizontal(width: 5),
                    Text(
                      "${data.changesPercentage ?? ''}%",
                      style: styleBaseSemiBold(
                        fontSize: 14,
                        color: num.parse("${data.changesPercentage ?? 0}") < 0
                            ? ThemeColors.darkRed
                            : ThemeColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
