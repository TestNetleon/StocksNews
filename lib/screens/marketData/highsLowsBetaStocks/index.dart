import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/high_beta_stocks.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/low_beta_stocks.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/negative_beta_stocks.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../widgets/custom_tab_container.dart';

class HighLowsBetaStocksIndex extends StatelessWidget {
  static const path = "HighLowsBetaStocksIndex";
  const HighLowsBetaStocksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) =>
                (element.key == "high-beta-stocks" && element.status == 0) ||
                (element.key == "low-beta-stocks" && element.status == 0) ||
                (element.key == "negative-beta-stocks" &&
                    element.status == 0)) ??
        false;
    if (purchased && isLocked) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
              (element) =>
                  (element.key == "high-beta-stocks" && element.status == 1) ||
                  (element.key == "low-beta-stocks" && element.status == 1) ||
                  (element.key == "negative-beta-stocks" &&
                      element.status == 1)) ??
          false;

      isLocked = !havePermissions;
    }

    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(isPopBack: true, title: "Market Data"),
      body: Stack(
        children: [
          const CommonTabContainer(
            physics: NeverScrollableScrollPhysics(),
            scrollable: true,
            // tabsPadding: EdgeInsets.only(bottom: 10.sp),
            tabs: [
              "High Beta Stocks",
              "Low Beta Stocks",
              "Negative Beta Stocks"
            ],
            widgets: [
              HighBetaStocks(),
              LowsBetaStocks(),
              NegativeBetaStocks(),
            ],
          ),
          if (isLocked)
            CommonLock(
              isLocked: isLocked,
              showLogin: true,
            ),
        ],
      ),
    );
  }
}
