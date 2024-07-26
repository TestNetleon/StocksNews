import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/fifty_two_high.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/fifty_two_lows.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_tab_container.dart';
import '../lock/common_lock.dart';

class FiftyTwoWeeksIndex extends StatelessWidget {
  static const path = "FiftyTwoWeeksIndex";
  const FiftyTwoWeeksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    // FiftyTwoWeeksHighProvider fiftyTwoWeeksHighProvider =
    //     context.watch<FiftyTwoWeeksHighProvider>();
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) =>
              (element.key == "week-highs" && element.status == 0) ||
              (element.key == "week-lows" && element.status == 0),
        ) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "week-highs" && element.status == 1) ||
                (element.key == "week-lows" && element.status == 1),
          ) ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(isPopback: true, title: "Market Data"),
      body: Stack(
        children: [
          const CommonTabContainer(
            scrollable: false,
            // tabsPadding: EdgeInsets.only(bottom: 10.sp),
            tabs: ["52 Week Highs", "52 Week Lows"],
            widgets: [
              FiftyTwoWeeksHighsStocks(),
              FiftyTwoWeeksLowsStocks(),
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
