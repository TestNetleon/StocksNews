import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/high_pe.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/high_pe_growth.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/low_pe.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/low_pe_growth.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../providers/home_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_tab_container.dart';

class HighLowPEIndex extends StatelessWidget {
  static const path = "HighLowPEIndex";
  const HighLowPEIndex({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;

    bool isLocked = false;

    if (purchased) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
              (element) =>
                  element == "gainer_loser" || element == "breakout-stocks") ??
          false;
      isLocked = !havePermissions;
    } else {
      if (!isLocked) {
        isLocked = homeProvider.extra?.membership?.permissions?.any((element) =>
                element == "gainer_loser" || element == "breakout-stocks") ??
            false;
      }
    }
    return const BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Stack(
        children: [
          CommonTabContainer(
            scrollable: true,
            // tabsPadding: EdgeInsets.only(bottom: 10.sp),
            tabs: [
              "High PE Ratio",
              "Low PE Ratio",
              "High PE Growth",
              "Low PE Growth"
            ],
            widgets: [
              HighPeStocks(),
              LowPEStocks(),
              HighPeGrowthStocks(),
              LowPEGrowthStocks(),
            ],
          ),
        ],
      ),
    );
  }
}
