import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/most_active_penny_stocks_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostActivePennyStocks extends StatefulWidget {
  const MostActivePennyStocks({super.key});

  @override
  State<MostActivePennyStocks> createState() => _MostActivePennyStocksState();
}

class _MostActivePennyStocksState extends State<MostActivePennyStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MostActivePennyStocksProviders provider =
          context.read<MostActivePennyStocksProviders>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getMostActivePennyStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    MostActivePennyStocksProviders mostActProvider =
        context.read<MostActivePennyStocksProviders>();

    if (provider.data == null) {
      await provider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Most Active Penny Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: mostActProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<MostActivePennyStocksProviders>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    MostActivePennyStocksProviders provider =
        context.watch<MostActivePennyStocksProviders>();
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
              ),
              Expanded(
                child: BaseUiContainer(
                  error: provider.error,
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getMostActivePennyStocks(type: 1),
                  child: RefreshControl(
                    onRefresh: () async =>
                        provider.getMostActivePennyStocks(type: 1),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async => provider.getMostActivePennyStocks(
                        loadMore: true, type: 1),
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: Dimen.padding.sp),
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
                selected: context
                    .read<MostActivePennyStocksProviders>()
                    .filterParams
                    ?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context
                      .read<MostActivePennyStocksProviders>()
                      .applySorting(sortingKey);
                },
                onResetClick: () {
                  Navigator.pop(navigatorKey.currentContext!);
                  context
                      .read<MostActivePennyStocksProviders>()
                      .applySorting("");
                },
              ),
            ))
      ],
    );
  }
}
