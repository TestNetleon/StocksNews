import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/most_popular_penny_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostPopularPennyStocks extends StatefulWidget {
  const MostPopularPennyStocks({super.key});

  @override
  State<MostPopularPennyStocks> createState() => _MostPopularPennyStocksState();
}

class _MostPopularPennyStocksState extends State<MostPopularPennyStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MostPopularPennyStocksProviders provider =
          context.read<MostPopularPennyStocksProviders>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getMostPopularPennyStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    MostPopularPennyStocksProviders mostActProvider =
        context.read<MostPopularPennyStocksProviders>();

    if (provider.data == null) {
      await provider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Most Popular Penny Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: mostActProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<MostPopularPennyStocksProviders>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    MostPopularPennyStocksProviders provider =
        context.watch<MostPopularPennyStocksProviders>();
    List<PennyStocksRes>? data = provider.data;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Dimen.padding, right: Dimen.padding, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketDataHeader(
                provider: provider,
                onFilterClick: _onFilterClick,
                // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
              ),
              // HtmlTitle(
              //   subTitle: provider.extraUp?.subTitle ?? "",
              //   onFilterClick: _onFilterClick,
              //   margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getMostPopularPennyStocks(type: 1),
                  child: RefreshControl(
                    onRefresh: () async =>
                        provider.getMostPopularPennyStocks(type: 1),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async => provider.getMostPopularPennyStocks(
                        loadMore: true, type: 1),
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        bottom: Dimen.padding.sp,
                        top: Dimen.padding.sp,
                      ),
                      itemBuilder: (context, index) {
                        if (data == null || data.isEmpty) {
                          return const SizedBox();
                        }

                        return PennyStocksItem(
                          data: data[index],
                          isOpen: provider.openIndex == index,
                          onTap: () {
                            provider.setOpenIndex(
                              provider.openIndex == index ? -1 : index,
                            );
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: ThemeColors.greyBorder,
                          height: 20.sp,
                        );
                      },
                      itemCount: data?.length ?? 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: MdBottomSheet(
              isFilter: provider.isFilterApplied(),
              isSort: provider.isSortingApplied(),
              onTapFilter: _onFilterClick,
              onTapSorting: () => onSortingClick(
                selected: context
                    .read<MostPopularPennyStocksProviders>()
                    .filterParams
                    ?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context
                      .read<MostPopularPennyStocksProviders>()
                      .applySorting(sortingKey);
                },
                onResetClick: () {
                  Navigator.pop(navigatorKey.currentContext!);
                  context
                      .read<MostPopularPennyStocksProviders>()
                      .applySorting("");
                },
              ),
            ))
      ],
    );
  }
}
