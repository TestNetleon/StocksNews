import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_down_stocks.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_up_stocks.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

class GapUpDownStocks extends StatelessWidget {
  static const path = "GapUpDownStocks";

  final StocksType? type;
  const GapUpDownStocks({super.key, this.type = StocksType.gapUp});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;

    bool isLocked = false;

    if (purchased) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
              (element) =>
                  element == "gap-up-stocks" || element == "gap-down-stocks") ??
          false;
      isLocked = !havePermissions;
    } else {
      if (!isLocked) {
        isLocked = homeProvider.extra?.membership?.permissions?.any((element) =>
                element == "gap-up-stocks" || element == "gap-down-stocks") ??
            false;
      }
    }

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
            scrollable: false,
            padding: EdgeInsets.zero,
            tabs: ["Gap Up Stocks", "Gap Down Stocks"],
            widgets: [
              GapUpStocks(),
              GapDownStocks(),
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
