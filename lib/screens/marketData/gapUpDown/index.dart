import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_down_stocks.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_up_stocks.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import '../../../providers/home_provider.dart';
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
    // GapUpProvider gapUpProvider = context.watch<GapUpProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) =>
              (element.key == "gap-up-stocks" && element.status == 0) ||
              (element.key == "gap-down-stocks" && element.status == 0),
        ) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "gap-up-stocks" && element.status == 1) ||
                (element.key == "gap-down-stocks" && element.status == 1),
          ) ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(isPopBack: true, title: "Market Data"),
      body: Stack(
        children: [
          const CommonTabContainer(
            physics: NeverScrollableScrollPhysics(),
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
              // onMembershipClick: () {
              //   askToSubscribe(
              //     onPressed: provider.user == null
              //         ? () async {
              //             Utils().showLog("GAP UP DOWN OPEN? $isLocked");

              //             //Ask for LOGIN
              //             Navigator.pop(context);
              //             isPhone
              //                 ? await loginSheet()
              //                 : await loginSheetTablet();
              //             if (provider.user == null) {
              //               return;
              //             }
              //             if (isLocked) {
              //               log("message");
              //               await RevenueCatService.initializeSubscription();
              //             }
              //           }
              //         : () async {
              //             Navigator.pop(context);
              //             if (isLocked) {
              //               await RevenueCatService.initializeSubscription();
              //             }
              //           },
              //   );
              // },
              // onLoginClick: () async {
              //   isPhone ? await loginSheet() : await loginSheetTablet();
              //   if (provider.user == null) {
              //     return;
              //   }
              //   Navigator.popUntil(
              //       navigatorKey.currentContext!, (route) => route.isFirst);
              //   Navigator.pushReplacement(
              //     navigatorKey.currentContext!,
              //     MaterialPageRoute(
              //       builder: (_) => const Tabs(index: 0),
              //     ),
              //   );
              // },
            ),
        ],
      ),
    );
  }
}
