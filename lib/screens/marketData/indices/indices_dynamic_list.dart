import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/indices_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/html_title.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'item.dart';

class IndicesDynamicStocks extends StatefulWidget {
  const IndicesDynamicStocks({super.key});

  @override
  State<IndicesDynamicStocks> createState() => _IndicesDynamicStocksState();
}

class _IndicesDynamicStocksState extends State<IndicesDynamicStocks> {
  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    IndicesProvider dataProvider = context.read<IndicesProvider>();
    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter ${dataProvider.tabs![dataProvider.selectedIndex].key}",
      child: MarketDataFilterBottomSheet(
        showExchange: false,
        filterParam: dataProvider.filterParams,
        onFiltered: _onFiltered,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<IndicesProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BaseUiContainer(
                error: provider.error,
                hasData: !provider.isLoading && provider.data != null,
                isLoading: provider.isLoading,
                showPreparingText: true,
                onRefresh: () {
                  provider.getIndicesData(showProgress: false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Dimen.padding, right: Dimen.padding, bottom: 40),
                  child: Column(
                    children: [
                      HtmlTitle(
                        subTitle: provider.extra?.subTitle ?? "",
                        hasFilter: false,
                      ),
                      Expanded(
                        child: RefreshControl(
                          onRefresh: () async => provider.getIndicesData(),
                          canLoadMore: provider.canLoadMore,
                          onLoadMore: () async =>
                              provider.getIndicesData(loadMore: true),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 10),
                            itemBuilder: (context, index) {
                              IndicesRes? data = provider.data?[index];
                              if (data == null) {
                                return const SizedBox();
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // if (index == 0)
                                  //   HtmlTitle(
                                  //     subTitle: provider.subTitle,
                                  //   ),
                                  IndicesItem(data: data, index: index),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              if (provider.data == null) {
                                return const SizedBox();
                              }
                              return const SpacerVertical(height: 12);
                            },
                            itemCount:
                                provider.typeDowThirty || provider.typeSpFifty
                                    ? provider.dataDowThirtyStocks?.length ?? 0
                                    : provider.data?.length ?? 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MdBottomSheet(
            isFilter: provider.isFilterApplied(),
            isSort: provider.isSortingApplied(),
            onTapFilter: _onFilterClick,
            onTapSorting: () => onSortingClick(
              selected: context.read<IndicesProvider>().filterParams?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<IndicesProvider>().applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<IndicesProvider>().applySorting("");
              },
            ),
          ),
        )
      ],
    );
  }
}
