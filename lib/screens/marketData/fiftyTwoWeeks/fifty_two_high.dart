import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/fifty_two_weeks_res.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_high_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class FiftyTwoWeeksHighsStocks extends StatefulWidget {
  const FiftyTwoWeeksHighsStocks({super.key});

  @override
  State<FiftyTwoWeeksHighsStocks> createState() =>
      _FiftyTwoWeeksHighsStocksState();
}

class _FiftyTwoWeeksHighsStocksState extends State<FiftyTwoWeeksHighsStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FiftyTwoWeeksHighProvider provider =
          context.read<FiftyTwoWeeksHighProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getFiftyTwoWeekHigh();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    FiftyTwoWeeksHighProvider gapUpProvider =
        context.read<FiftyTwoWeeksHighProvider>();

    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter 52 Weeks High Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapUpProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<FiftyTwoWeeksHighProvider>().applyFilter(params);
  }
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (context.read<FiftyTwoWeeksHighProvider>().data != null) {
  //       return;
  //     }
  //     context.read<FiftyTwoWeeksHighProvider>().getFiftyTwoWeekHigh();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    FiftyTwoWeeksHighProvider provider =
        context.watch<FiftyTwoWeeksHighProvider>();
    List<FiftyTwoWeeksRes>? data = provider.data;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Dimen.padding,
            right: Dimen.padding,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketDataHeader(
                provider: provider,
                onFilterClick: _onFilterClick,
                // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
              ),
              Expanded(
                child: BaseUiContainer(
                  error: provider.error,
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getFiftyTwoWeekHigh(),
                  child: RefreshControl(
                    onRefresh: () async => provider.getFiftyTwoWeekHigh(),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async =>
                        provider.getFiftyTwoWeekHigh(loadMore: true),
                    child: Column(
                      children: [
                        // HtmlTitle(subTitle: provider.extra?.subTitle),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              bottom: Dimen.padding,
                              top: 0,
                            ),
                            itemBuilder: (context, index) {
                              if (data == null || data.isEmpty) {
                                return const SizedBox();
                              }
                              return FiftyTwoWeeksItem(
                                data: data[index],
                                isOpen: provider.openIndex == index,
                                onTap: () {
                                  provider.setOpenIndex(
                                    provider.openIndex == index ? -1 : index,
                                  );
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SpacerVertical(height: 12);
                            },
                            // itemCount: up?.length ?? 0,
                            itemCount: data?.length ?? 0,
                          ),
                        ),
                      ],
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
                  .read<FiftyTwoWeeksHighProvider>()
                  .filterParams
                  ?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context
                    .read<FiftyTwoWeeksHighProvider>()
                    .applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<FiftyTwoWeeksHighProvider>().applySorting("");
              },
            ),
          ),
        )
      ],
    );
  }
}
