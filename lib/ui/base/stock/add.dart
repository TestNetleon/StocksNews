import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/stock/slidable.dart';
import 'package:stocks_news_new/ui/base/stock/stock.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/extra/add_to_alert_sheet.dart';
import 'package:stocks_news_new/ui/tabs/more/alerts/index.dart';
import 'package:stocks_news_new/ui/tabs/more/watchlist/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';

class BaseStockAddItem extends StatelessWidget {
  final BaseTickerRes data;
  final int index;
  final bool slidable;
  final Function(BaseTickerRes)? onTap;
  final Function()? onRefresh;
  final dynamic manager;
  final List<BaseKeyValueRes>? expandable;

  const BaseStockAddItem({
    super.key,
    this.slidable = true,
    required this.data,
    required this.index,
    this.onTap,
    this.onRefresh,
    this.manager,
    this.expandable,
  });

  Future<void> _onAddToAlertClick(BuildContext context) async {
    AlertsWatchlistManager manager = context.read<AlertsWatchlistManager>();
    UserManager userManager = context.read<UserManager>();
    if (data.isAlertAdded == 1) {
      await Navigator.pushNamed(context, AlertIndex.path);
      if (onRefresh != null) onRefresh!();
    } else {
      if (userManager.user != null) {
        await manager.requestAlertLock(symbol: data.symbol ?? "");
        if (manager.checkAlertLock?.lockInfo != null) {
          SubscriptionManager().startProcess();
        } else if (manager.checkAlertLock?.alertData != null) {
          _showAlertBottomSheet(context);
        } else {
          TopSnackbar.show(
            message: Const.errSomethingWrong,
            type: ToasterEnum.error,
          );
        }
      } else {
        await userManager.askLoginScreen();
        if (userManager.user != null && onRefresh != null) {
          onRefresh!();
        }
      }
    }
  }

  Future _showAlertBottomSheet(BuildContext context) async {
    BaseBottomSheet().bottomSheet(
      child: AddToAlertSheet(symbol: data.symbol ?? "", manager: manager),
    );
  }

  Future<void> _onAddToWatchlistClick(BuildContext context) async {
    AlertsWatchlistManager manager = context.read<AlertsWatchlistManager>();
    UserManager userManager = context.read<UserManager>();
    if (data.isWatchlistAdded == 1) {
      await Navigator.pushNamed(context, WatchListIndex.path);
      if (onRefresh != null) onRefresh!();
    } else {
      if (userManager.user != null) {
        await manager.requestAlertLock(symbol: data.symbol ?? "");
        if (manager.checkAlertLock?.lockInfo != null) {
          SubscriptionManager().startProcess();
        } else if (manager.checkAlertLock?.alertData != null) {
          _requestAddToWatchlist(context);
        } else {
          TopSnackbar.show(
            message: Const.errSomethingWrong,
            type: ToasterEnum.error,
          );
        }
      } else {
        await userManager.askLoginScreen();
        if (userManager.user != null && onRefresh != null) {
          onRefresh!();
        }
      }
    }
  }

  void _requestAddToWatchlist(BuildContext context) async {
    AlertsWatchlistManager alertManager =
        context.read<AlertsWatchlistManager>();

    final Map request = {"symbol": data.symbol};

    final result = await alertManager.requestAddToWishList(
      symbol: data.symbol ?? "",
      request: request,
    );

    if (result == true) {
      manager.updateTickerInfo(symbol: data.symbol, watchListAdded: 1);
      // Navigator.pop(context);
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
          addToWatchlist: () => _onAddToWatchlistClick(context),
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
        child: BaseStockItem(data: data, index: index, expandable: expandable),
      ),
    );
  }
}
