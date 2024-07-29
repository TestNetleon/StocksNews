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
import '../../../utils/utils.dart';
import '../../../widgets/custom_tab_container.dart';
import '../lock/common_lock.dart';

class HighLowPEIndex extends StatelessWidget {
  static const path = "HighLowPEIndex";
  const HighLowPEIndex({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    // HighPeProvider highPeProvider = context.watch<HighPeProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) =>
              (element.key == "high-pe-ratio-stocks" && element.status == 0) ||
              (element.key == "low-pe-ratio-stocks" && element.status == 0) ||
              (element.key == "high-pe-growth-stocks" && element.status == 0) ||
              (element.key == "low-pe-growth-stocks" && element.status == 0),
        ) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "high-pe-ratio-stocks" &&
                    element.status == 1) ||
                (element.key == "low-pe-ratio-stocks" && element.status == 1) ||
                (element.key == "high-pe-growth-stocks" &&
                    element.status == 1) ||
                (element.key == "low-pe-growth-stocks" && element.status == 1),
          ) ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

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
