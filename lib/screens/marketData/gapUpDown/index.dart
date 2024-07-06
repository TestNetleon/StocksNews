import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_down_stocks.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_up_stocks.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/service/ask_subscription.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../auth/login/login_sheet.dart';
import '../../auth/login/login_sheet_tablet.dart';

class GapUpDownStocks extends StatelessWidget {
  static const path = "GapUpDownStocks";

  final StocksType? type;
  const GapUpDownStocks({super.key, this.type = StocksType.gapUp});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();

    // bool purchased = provider.user?.membership?.purchased == 1;

    bool gapUpDown = provider.user?.membership?.permissions?.any((element) =>
            element == "gap-up-stocks" || element == "gap-down-stocks") ??
        false;
    Utils().showLog("GAP UP DOWN OPEN? $gapUpDown");
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
          if (!gapUpDown)
            CommonLock(
              onPressed: () {
                askToSubscribe(
                  onPressed: provider.user == null
                      ? () async {
                          Utils().showLog("GAP UP DOWN OPEN? $gapUpDown");

                          //Ask for LOGIN
                          Navigator.pop(context);
                          isPhone
                              ? await loginSheet()
                              : await loginSheetTablet();
                          if (provider.user == null) {
                            return;
                          }
                          if (!gapUpDown) {
                            log("message");
                            await RevenueCatService.initializeSubscription();
                          }
                        }
                      : () async {
                          Navigator.pop(context);

                          if (!gapUpDown) {
                            await RevenueCatService.initializeSubscription();
                          }
                        },
                );
              },
            ),
        ],
      ),
    );
  }
}
