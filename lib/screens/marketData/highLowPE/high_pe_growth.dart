import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/highlow_pe_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/high_pe_growth_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import 'item.dart';

class HighPeGrowthStocks extends StatefulWidget {
  const HighPeGrowthStocks({super.key});

  @override
  State<HighPeGrowthStocks> createState() => _HighPeGrowthStocksState();
}

class _HighPeGrowthStocksState extends State<HighPeGrowthStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HighPeGrowthProvider provider = context.read<HighPeGrowthProvider>();
      if (provider.data != null) {
        return;
      }
      // if (context.read<HighPeProvider>().dataHighPERatio != null) {
      //   return;
      // }
      provider.resetFilter();
      provider.getData(showProgress: true);
      //-------
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    FilteredParams? filterParams =
        context.read<HighPeGrowthProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter High PE Growth Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<HighPeGrowthProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    HighPeGrowthProvider provider = context.watch<HighPeGrowthProvider>();

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
                  // hasData: up != null && up.isNotEmpty,
                  hasData: !provider.isLoading &&
                      provider.data != null &&
                      provider.data?.isNotEmpty == true,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getData(showProgress: true),
                  child: RefreshControl(
                    onRefresh: () async => provider.getData(showProgress: true),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async =>
                        provider.getData(showProgress: false, loadMore: true),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: Dimen.padding,
                        top: Dimen.padding,
                      ),
                      itemBuilder: (context, index) {
                        HIghLowPeRes? high = provider.data?[index];
                        return HighLowPEItem(index: index, data: high);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                            color: ThemeColors.greyBorder, height: 20.sp);
                      },
                      itemCount: provider.data?.length ?? 0,
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
                selected:
                    context.read<HighPeGrowthProvider>().filterParams?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<HighPeGrowthProvider>().applySorting(sortingKey);
                },
                onResetClick: () {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<HighPeGrowthProvider>().applySorting("");
                },
              ),
            ))
      ],
    );
  }
}
