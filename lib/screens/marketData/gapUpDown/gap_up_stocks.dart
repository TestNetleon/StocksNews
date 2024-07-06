import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/gap_up_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class GapUpStocks extends StatefulWidget {
  const GapUpStocks({super.key});

  @override
  State<GapUpStocks> createState() => _GapUpStocksState();
}

class _GapUpStocksState extends State<GapUpStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GapUpProvider provider = context.read<GapUpProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getGapUpStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    GapUpProvider gapUpProvider = context.read<GapUpProvider>();

    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Gap Up Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapUpProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<GapUpProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    GapUpProvider provider = context.watch<GapUpProvider>();
    List<GapUpRes>? data = provider.data;

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
              //   subTitle: provider.extra?.subTitle ?? "",
              //   onFilterClick: _onFilterClick,
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
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getGapUpStocks(),
                  child: RefreshControl(
                    onRefresh: () async => await provider.getGapUpStocks(),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async =>
                        await provider.getGapUpStocks(loadMore: true),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: Dimen.padding,
                        top: 0,
                      ),
                      itemBuilder: (context, index) {
                        return UpDownStocksItem(
                          gapUp: true,
                          data: data![index],
                          isOpen: provider.openIndex == index,
                          onTap: () {
                            provider.setOpenIndex(
                              provider.openIndex == index ? -1 : index,
                            );
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SpacerVertical(height: 12);
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
              selected: context.read<GapUpProvider>().filterParams?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<GapUpProvider>().applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<GapUpProvider>().applySorting("");
              },
            ),
          ),
        )
      ],
    );
  }
}
