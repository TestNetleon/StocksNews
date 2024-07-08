import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/low_prices_stocks.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/marketData/lowPriceStocks/low_price_stock_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';

import '../../../modals/low_price_stocks_tab.dart';

class LowPriceStocksIndex extends StatefulWidget {
  static const path = "LowPriceStocksIndex";
  const LowPriceStocksIndex({super.key});

  @override
  State<LowPriceStocksIndex> createState() => _LowPriceStocksIndexState();
}

class _LowPriceStocksIndexState extends State<LowPriceStocksIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LowPriceStocksProvider>().selectedIndex = 0;
      context.read<LowPriceStocksProvider>().getTabsData(showProgress: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    LowPriceStocksProvider provider = context.watch<LowPriceStocksProvider>();
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(
        canSearch: true,
        isPopback: true,
      ),
      body: provider.tabLoading
          ? const Loading()
          : !provider.tabLoading && provider.tabs == null
              ? ErrorDisplayWidget(
                  error: provider.error,
                  onRefresh: () => provider.getTabsData(showProgress: false),
                )
              : const LowPriceStocksData(),
    );
  }
}

class LowPriceStocksData extends StatelessWidget {
  const LowPriceStocksData({super.key});

  @override
  Widget build(BuildContext context) {
    LowPriceStocksProvider provider = context.watch<LowPriceStocksProvider>();
    List<LowPriceStocksTabRes>? tabs = provider.tabs;

    UserProvider userProvider = context.watch<UserProvider>();
    // HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = provider.extra?.membership?.permissions?.any((element) =>
            element == "low-priced-stocks-under" ||
            element == "stocks-on-sale") ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) =>
                  element == "low-priced-stocks-under" ||
                  element == "stocks-on-sale") ??
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

    return Stack(
      children: [
        CommonTabContainer(
          onChange: (index) {
            provider.resetFilter();
            provider.tabChange(index);
          },
          scrollable: true,
          tabs: List.generate(
            tabs?.length ?? 0,
            (index) => "${tabs?[index].key}",
          ),
          widgets: List.generate(
            tabs?.length ?? 0,
            (index) => LowPriceStocksList(index: index),
          ),
        ),
        if (isLocked)
          CommonLock(
            isLocked: isLocked,
            showLogin: true,
          ),
      ],
    );
  }
}
