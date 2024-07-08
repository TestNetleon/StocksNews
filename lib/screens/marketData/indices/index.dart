import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/indices/dow_30_stocks.dart';
import 'package:stocks_news_new/screens/marketData/indices/indices_dynamic_list.dart';
import 'package:stocks_news_new/screens/marketData/indices/snp_500_stocks.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';

class IndicesIndex extends StatefulWidget {
  static const path = "IndicesIndex";
  const IndicesIndex({super.key});

  @override
  State<IndicesIndex> createState() => _IndicesIndexState();
}

class _IndicesIndexState extends State<IndicesIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IndicesProvider>().selectedIndex = 0;
      context.read<IndicesProvider>().getTabsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(canSearch: true, isPopback: true),
      body: provider.tabLoading ? const Loading() : _getWidget(provider),
    );
  }
}

Widget _getWidget(IndicesProvider provider) {
  if (provider.tabLoading) {
    return const SizedBox();
  }
  if (!provider.tabLoading && provider.tabs == null) {
    return ErrorDisplayWidget(
      error: provider.error,
      onRefresh: () => provider.getTabsData(showProgress: true),
    );
  }
  return const IndicesData();
}

class IndicesData extends StatelessWidget {
  const IndicesData({super.key});

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();
    List<LowPriceStocksTabRes>? tabs = provider.tabs;

    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = false;

    if (purchased) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
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

    return provider.tabLoading
        ? const Loading()
        : Stack(
            children: [
              CommonTabContainer(
                onChange: (index) {
                  if (index != 0 && index != 1) {
                    provider.tabChange(index);
                  }
                },
                scrollable: (tabs?.length ?? 0) > 1 ? true : false,
                // tabs: List.generate(
                //     tabs?.length ?? 0, (index) => "${tabs?[index].name}"),
                // widgets: List.generate(
                //   tabs?.length ?? 0,
                //   (index) => _getWidgets(provider),
                // ),
                tabs: tabs == null
                    ? ["DOW 30 Stocks", "S&P 500 Stocks"]
                    : [
                        "DOW 30 Stocks",
                        "S&P 500 Stocks",
                        ...(tabs.map(
                          (tab) => tab.key,
                        )),
                      ],
                widgets: tabs == null
                    ? const [
                        Dow30Stocks(),
                        Snp500Stocks(),
                      ]
                    : [
                        const Dow30Stocks(),
                        const Snp500Stocks(),
                        ...(provider.tabs!
                            .map((tab) => const IndicesDynamicStocks())
                            .toList()),
                      ],
              ),
              if (isLocked)
                CommonLock(
                  isLocked: isLocked,
                  showLogin: true,
                ),
            ],
          );
  }

  // Widget _getWidgets(IndicesProvider provider) {
  //   return BaseUiContainer(
  //     error: provider.error,
  //     hasData: !provider.isLoading && provider.data != null,
  //     isLoading: provider.isLoading,
  //     showPreparingText: true,
  //     onRefresh: () {
  //       provider.getIndicesData(showProgress: false);
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.only(
  //           left: Dimen.padding, right: Dimen.padding, bottom: 40),
  //       child: Column(
  //         children: [
  //           HtmlTitle(
  //             subTitle: provider.extra?.subTitle ?? "",
  //             hasFilter: false,

  //             // onFilterClick: _onFilterClick,
  //             // margin: const EdgeInsets.only(top: 10, bottom: 10),
  //           ),
  //           Expanded(
  //             child: RefreshControl(
  //               onRefresh: () async => provider.getIndicesData(),
  //               canLoadMore: provider.canLoadMore,
  //               onLoadMore: () async => provider.getIndicesData(loadMore: true),
  //               child: ListView.separated(
  //                 padding: const EdgeInsets.symmetric(vertical: 10),
  //                 itemBuilder: (context, index) {
  //                   IndicesRes? data = provider.data?[index];
  //                   if (data == null) {
  //                     return const SizedBox();
  //                   }
  //                   return Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // if (index == 0)
  //                       //   HtmlTitle(
  //                       //     subTitle: provider.subTitle,
  //                       //   ),
  //                       IndicesItem(data: data, index: index),
  //                     ],
  //                   );
  //                 },
  //                 separatorBuilder: (context, index) {
  //                   if (provider.data == null) {
  //                     return const SizedBox();
  //                   }
  //                   return const Divider(
  //                     color: ThemeColors.greyBorder,
  //                     height: 16,
  //                   );
  //                 },
  //                 itemCount: provider.typeDowThirty || provider.typeSpFifty
  //                     ? provider.dataDowThirtyStocks?.length ?? 0
  //                     : provider.data?.length ?? 0,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
