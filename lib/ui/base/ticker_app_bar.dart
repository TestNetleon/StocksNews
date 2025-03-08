import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/routes/navigation_observer.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/extra/add_to_alert_sheet.dart';
import 'package:stocks_news_new/ui/tabs/more/alerts/index.dart';
import 'package:stocks_news_new/ui/tabs/more/watchlist/index.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/spacer_horizontal.dart';
import 'app_bar.dart';

class BaseTickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? searchFieldWidget;
  final BaseTickerRes? data;
  final Function()? shareURL, addToAlert, addToWatchlist, onRefresh;
  final double toolbarHeight;
  final dynamic manager;

  const BaseTickerAppBar({
    super.key,
    this.toolbarHeight = 60,
    this.searchFieldWidget,
    this.data,
    this.shareURL,
    this.addToAlert,
    this.addToWatchlist,
    this.manager,
    this.onRefresh,
  });

  Future<void> onAddToAlertClick() async {
    AlertsWatchlistManager manager =
        navigatorKey.currentContext!.read<AlertsWatchlistManager>();
    UserManager userManager = navigatorKey.currentContext!.read<UserManager>();
    if (data?.isAlertAdded == 1) {
      await Navigator.pushNamed(navigatorKey.currentContext!, AlertIndex.path);
      if (onRefresh != null) onRefresh!();
    } else {
      if (userManager.user != null) {
        await manager.requestAlertLock(symbol: data?.symbol ?? "");
        if (manager.checkAlertLock?.lockInfo != null) {
          SubscriptionManager().startProcess(viewPlans: true);
        } else if (manager.checkAlertLock?.alertData != null) {
          _showAlertBottomSheet();
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

  Future _showAlertBottomSheet() async {
    BaseBottomSheet().bottomSheet(
      child: AddToAlertSheet(symbol: data?.symbol ?? "", manager: manager),
    );
  }

  Future<void> onAddToWatchlistClick() async {
    AlertsWatchlistManager manager =
        navigatorKey.currentContext!.read<AlertsWatchlistManager>();
    UserManager userManager = navigatorKey.currentContext!.read<UserManager>();
    if (data?.isWatchlistAdded == 1) {
      await Navigator.pushNamed(
          navigatorKey.currentContext!, WatchListIndex.path);
      if (onRefresh != null) onRefresh!();
    } else {
      if (userManager.user != null) {
        await manager.requestAlertLock(symbol: data?.symbol ?? "");
        if (manager.checkAlertLock?.lockInfo != null) {
          SubscriptionManager().startProcess(viewPlans: true);
        } else if (manager.checkAlertLock?.alertData != null) {
          requestAddToWatchlist(navigatorKey.currentContext!);
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

  void requestAddToWatchlist(BuildContext context) async {
    AlertsWatchlistManager alertManager =
        context.read<AlertsWatchlistManager>();

    final Map request = {"symbol": data?.symbol};

    final result = await alertManager.requestAddToWishList(
      symbol: data?.symbol ?? "",
      request: request,
    );

    if (result == true) {
      manager.updateTickerInfo(symbol: data?.symbol, watchListAdded: 1);
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(Pad.pad8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading
            Expanded(
              child: Row(
                children: [
                  ActionButton(
                    icon: Images.back,
                    onTap: () {
                      if (popHome) {
                        if (CustomNavigatorObserver().stackCount >= 2 &&
                            splashLoaded) {
                          Navigator.pop(navigatorKey.currentContext!);
                        } else {
                          Navigator.popUntil(
                              navigatorKey.currentContext!,
                                  (route) => route.isFirst);
                          Navigator.pushReplacementNamed(
                              navigatorKey.currentContext!, Tabs.path);
                          popHome = false;
                        }
                      } else {
                        // Navigator.pop(navigatorKey.currentContext!);
                        if (CustomNavigatorObserver().stackCount >= 2 &&
                            splashLoaded) {
                          Navigator.pop(navigatorKey.currentContext!);
                        } else {
                          Navigator.popUntil(
                              navigatorKey.currentContext!,
                                  (route) => route.isFirst);
                          Navigator.pushReplacementNamed(
                              navigatorKey.currentContext!, Tabs.path);
                          popHome = false;
                        }
                      }
                    },
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Pad.pad5),
                          child: Container(
                            padding: EdgeInsets.all(3.sp),
                            color: ThemeColors.neutral5,
                            child: data?.image == null || data?.image == ''
                                ? SizedBox(
                                    height: 32,
                                    width: 32,
                                  )
                                : CachedNetworkImagesWidget(
                                    data?.image,
                                    height: 32,
                                    width: 32,
                                  ),
                          ),
                        ),
                        const SpacerHorizontal(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                child: Row(
                                  children: [
                                    Text(
                                      data?.symbol ?? '',
                                      style: styleBaseBold(fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Visibility(
                                      visible: data?.exchange != null &&
                                          data?.exchange != '',
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: ThemeColors.neutral5,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(
                                          '${data?.exchange}',
                                          style: styleBaseSemiBold(
                                              color: ThemeColors.neutral80,
                                              fontSize: 11),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // const SpacerVertical(height: 2),
                              Visibility(
                                visible: data?.name != null && data?.name != '',
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data?.name ?? '',
                                  style: styleBaseRegular(
                                    fontSize: 14,
                                    color: ThemeColors.neutral40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Actions
            Row(
              children: [
                if (addToAlert != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionButton(
                      size: 35,
                      icon: Images.moreStockAlerts,
                      onTap: onAddToAlertClick,
                      color: data?.isAlertAdded == 1
                          ? ThemeColors.primary120
                          : ThemeColors.splashBG,
                    ),
                  ),
                if (addToWatchlist != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionButton(
                      size: 35,
                      icon: Images.watchlist,
                      // icon: Images.watchlist,
                      onTap: onAddToWatchlistClick,
                      color: data?.isWatchlistAdded == 1
                          ? ThemeColors.primary120
                          : ThemeColors.splashBG,
                    ),
                  ),
                if (shareURL != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionButton(
                      size: 35,
                      icon: Images.shareURL,
                      onTap: shareURL!,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
