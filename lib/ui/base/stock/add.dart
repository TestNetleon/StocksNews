import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/ui/base/stock/slidable.dart';
import 'package:stocks_news_new/ui/base/stock/stock.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';

class BaseStockAddItem extends StatelessWidget {
  final BaseTickerRes data;
  final int index;
  final bool slidable;
  final Function(BaseTickerRes)? onTap;
  const BaseStockAddItem({
    super.key,
    this.slidable = true,
    required this.data,
    required this.index,
    this.onTap,
  });

  Future<void> _onAddToAlertClick(BuildContext context) async {
    AlertsWatchlistAction provider = context.read<AlertsWatchlistAction>();
    UserProvider userProvider = context.read<UserProvider>();
    // String symbol = provider.tabRes?.keyStats?.symbol ?? "";

    // if (widget.up) {
    if (data.isAlertAdded == 1) {
      // _navigateToAlert();
    } else {
      if (userProvider.user != null) {
        // log("set HERE");
        // _showAlertPopup(context: navigatorKey.currentContext!, symbol: symbol);
      } else {
        // askLogin
      }
      // try {
      //   Utils().showLog("calling api..");
      //   ApiResponse res =
      //       await context.read<TrendingProvider>().getMostBullish();
      //   if (res.status) {
      //     num alertOn = navigatorKey.currentContext!
      //             .read<TrendingProvider>()
      //             .mostBullish
      //             ?.mostBullish?[widget.index]
      //             .isAlertAdded ??
      //         0;
      //     if (alertOn == 0) {
      //       _showAlertPopup(
      //           context: navigatorKey.currentContext!, symbol: symbol);
      //     } else {
      //       Navigator.push(
      //         navigatorKey.currentContext!,
      //         MaterialPageRoute(builder: (_) => const Alerts()),
      //       );
      //     }
      //   }
      // } catch (e) {
      //   log("ERROR -> $e");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OptionalParent(
      addParent: slidable,
      parentBuilder: (child) {
        return BaseSlidableStockItem(
          index: index,
          addToAlert: () => _onAddToAlertClick(context),
          addToWatchlist: () {},
          isAlertAdded: data.isAlertAdded,
          isWatchlistAdded: data.isWatchlistAdded,
          child: child,
        );
      },
      child: InkWell(
        onTap: onTap != null
            ? () {
                onTap!(data);
              }
            : null,
        child: BaseStockItem(data: data),
      ),
    );
  }
}
