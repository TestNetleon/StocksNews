import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/low_price_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/low_prices_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/lowPriceStocks/item_sale_on_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import 'item.dart';

class LowPriceStocksList extends StatefulWidget {
  final int index;
  const LowPriceStocksList({required this.index, super.key});

  @override
  State<LowPriceStocksList> createState() => _LowPriceStocksListState();
}

class _LowPriceStocksListState extends State<LowPriceStocksList> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     LowPriceStocksProvider provider = context.read<LowPriceStocksProvider>();
  //     if (provider.data != null) {
  //       return;
  //     }
  //     provider.resetFilter();
  //     // provider.getLowPriceData();
  //     provider.tabChange(widget.index);
  //   });
  // }

  void _onFilterClick() async {
    FilterProvider filterProvider = context.read<FilterProvider>();
    LowPriceStocksProvider provider = context.read<LowPriceStocksProvider>();

    if (filterProvider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter ${provider.tabs?[provider.selectedIndex].key}",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: provider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<LowPriceStocksProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    LowPriceStocksProvider provider = context.watch<LowPriceStocksProvider>();
    // List<LowPriceStocksTabRes>? tabs = provider.tabs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarketDataHeader(
          provider: provider,
          onFilterClick: _onFilterClick,
          onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
        ),
        // HtmlTitle(
        //   subTitle: provider.subTitle ?? "",
        //   onFilterClick: _onFilterClick,
        //   // margin: const EdgeInsets.only(top: 10, bottom: 10),
        //   hasFilter: provider.filterParams != null,
        // ),
        // if (provider.filterParams != null)
        //   FilterUiValues(
        //     params: provider.filterParams,
        //     onDeleteExchange: (exchange) {
        //       provider.exchangeFilter(exchange);
        //     },
        //   ),
        Expanded(
          child: BaseUiContainer(
            error: provider.error,
            hasData: !provider.isLoading && provider.data != null,
            isLoading: provider.isLoading,
            showPreparingText: true,
            onRefresh: () {
              provider.getLowPriceData();
            },
            child: RefreshControl(
              onRefresh: () async => provider.getLowPriceData(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async => provider.getLowPriceData(loadMore: true),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                itemBuilder: (context, index) {
                  LowPriceStocksRes? data = provider.data?[index];
                  if (data == null) {
                    return const SizedBox();
                  }
                  return provider.typeIndex == 1
                      ? SaleOnStocksItem(data: data)
                      : LowPriceStocksItem(data: data);

                  // return Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     index == 0
                  //         ? HtmlTitle(
                  //             subTitle: provider.subTitle,
                  //           )
                  //         : const SizedBox(),
                  //     provider.typeIndex == 1
                  //         ? SaleOnStocksItem(
                  //             data: data,
                  //           )
                  //         : LowPriceStocksItem(data: data),
                  //   ],
                  // );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: ThemeColors.greyBorder,
                    height: 16,
                  );
                },
                itemCount: provider.data?.length ?? 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
