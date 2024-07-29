import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';

import 'package:stocks_news_new/screens/marketData/mostActive/most_active_stocks.dart';
import 'package:stocks_news_new/screens/marketData/mostActive/most_volatile_stocks.dart';
import 'package:stocks_news_new/screens/marketData/mostActive/unusual_trading_volume.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../widgets/custom_tab_container.dart';

class MostActiveIndex extends StatelessWidget {
  static const path = "MostActiveIndex";
  const MostActiveIndex({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    // MostActiveProvider provider = context.watch<MostActiveProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) =>
                (element.key == "most-active-stocks" && element.status == 0) ||
                (element.key == "most-voliatile-stocks" &&
                    element.status == 0) ||
                (element.key == "unusual-volume-stocks" &&
                    element.status == 0)) ??
        false;
    // bool isLocked = homeProvider.extra?.membership?.permissions?.any(
    //         (element) =>
    //             element == "most-active-stocks" ||
    //             element == "most-voliatile-stocks" ||
    //             element == "unusual-volume-stocks") ??
    //     false;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) =>
                  (element.key == "most-active-stocks" &&
                      element.status == 1) ||
                  (element.key == "most-voliatile-stocks" &&
                      element.status == 1) ||
                  (element.key == "unusual-volume-stocks" &&
                      element.status == 1)) ??
          false;
      // bool havePermissions = userProvider.user?.membership?.permissions?.any(
      //         (element) =>
      //             element == "most-active-stocks" ||
      //             element == "most-voliatile-stocks" ||
      //             element == "unusual-volume-stocks") ??
      //     false;

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

    Utils().showLog("GAP UP DOWN OPEN? $isLocked");
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Stack(
        children: [
          const CommonTabContainer(
            physics: NeverScrollableScrollPhysics(),
            scrollable: true,
            // tabsPadding: EdgeInsets.only(bottom: 10.sp),
            tabs: [
              "Most Active Stocks",
              "Most Volatile Stocks",
              "Unusual Trading Volume",
            ],
            widgets: [
              MostActiveStocks(),
              MostVolatileStocks(),
              UnusualTradingVolume(),
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
