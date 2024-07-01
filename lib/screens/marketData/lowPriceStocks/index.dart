import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/low_prices_stocks.dart';
import 'package:stocks_news_new/screens/marketData/lowPriceStocks/low_price_stock_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
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

    return CommonTabContainer(
      onChange: (index) {
        provider.resetFilter();
        provider.tabChange(index);
      },
      scrollable: true,
      // tabsPadding: EdgeInsets.only(bottom: 10.sp),
      tabs: List.generate(
        tabs?.length ?? 0,
        (index) => "${tabs?[index].key}",
      ),
      widgets: List.generate(
        tabs?.length ?? 0,
        (index) => LowPriceStocksList(index: index),
        // (index) => _getWidgets(provider),
      ),
    );
  }

  // Widget _getWidgets(LowPriceStocksProvider provider) {
  //   return BaseUiContainer(
  //     error: provider.error,
  //     hasData: !provider.isLoading && provider.data != null,
  //     isLoading: provider.isLoading,
  //     showPreparingText: true,
  //     onRefresh: () {
  //       provider.getLowPriceData();
  //     },
  //     child: RefreshControl(
  //       onRefresh: () async => provider.getLowPriceData(),
  //       canLoadMore: provider.canLoadMore,
  //       onLoadMore: () async => provider.getLowPriceData(loadMore: true),
  //       child: ListView.separated(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         itemBuilder: (context, index) {
  //           LowPriceStocksRes? data = provider.data?[index];
  //           if (data == null) {
  //             return const SizedBox();
  //           }
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               index == 0
  //                   ? HtmlTitle(
  //                       subTitle: provider.subTitle,
  //                     )
  //                   : const SizedBox(),
  //               provider.typeIndex == 1
  //                   ? SaleOnStocksItem(
  //                       data: data,
  //                     )
  //                   : LowPriceStocksItem(data: data),
  //             ],
  //           );
  //         },
  //         separatorBuilder: (context, index) {
  //           return const Divider(
  //             color: ThemeColors.greyBorder,
  //             height: 16,
  //           );
  //         },
  //         itemCount: provider.data?.length ?? 0,
  //       ),
  //     ),
  //   );
  // }
}
