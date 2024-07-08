import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/most_active_penny_stocks.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/most_popular_penny_stocks.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/top_today-penny_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class PennyStocks extends StatelessWidget {
  static const path = "PennyStocks";

  // final StocksType? type;
  const PennyStocks({
    super.key,
    // this.type = StocksType.gapUp
  });

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    // MostActivePennyStocksProviders provider =
    //     context.watch<MostActivePennyStocksProviders>();
    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) =>
                element == "most-active-penny-stocks" ||
                element == "most-popular-penny-stocks" ||
                element == "top-penny-stocks-today") ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) =>
                  element == "most-active-penny-stocks" ||
                  element == "most-popular-penny-stocks" ||
                  element == "top-penny-stocks-today") ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

    // bool isLocked = false;

    // if (purchased) {
    //   bool havePermissions = userProvider.user?.membership?.permissions?.any(
    //           (element) =>
    //               element == "gap-up-stocks" || element == "gap-down-stocks") ??
    //       false;
    //   isLocked = !havePermissions;
    // } else {
    //   if (!isLocked) {
    //     isLocked = homeProvider.extra?.membership?.permissions?.any((element) =>
    //             element == "gap-up-stocks" || element == "gap-down-stocks") ??
    //         false;
    //   }
    // }

    // Utils().showLog("GAP UP DOWN OPEN? $isLocked");

    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Stack(
        children: [
          const CommonTabContainer(
            scrollable: true,
            padding: EdgeInsets.zero,
            tabs: [
              "Most Active Penny Stocks",
              "Most Popular Penny Stocks",
              "Top Today's Penny Stocks"
            ],
            widgets: [
              MostActivePennyStocks(),
              MostPopularPennyStocks(),
              TopTodayPennyStocks(),
            ],
          ),
          if (isLocked)
            CommonLock(
              showLogin: true,
              isLocked: isLocked,
            ),
        ],
      ),
    );
  }
}
