import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/today_top_gainer_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../modals/gainers_losers_res.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../../moreStocks/topGainerLoser/item.dart';

class TodaysTopGainer extends StatefulWidget {
  const TodaysTopGainer({super.key});

  @override
  State<TodaysTopGainer> createState() => _TodaysTopGainerState();
}

class _TodaysTopGainerState extends State<TodaysTopGainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TodayTopGainerProvider provider = context.read<TodayTopGainerProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData(showProgress: true);
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    FilteredParams? filterParams =
        context.read<TodayTopGainerProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Today's Top Gainers",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<TodayTopGainerProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    TodayTopGainerProvider provider = context.watch<TodayTopGainerProvider>();
    List<GainersLosersDataRes>? gainers = provider.data?.data;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: Dimen.padding, right: Dimen.padding, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MarketDataHeader(
                  provider: provider,
                  onFilterClick: _onFilterClick,
                  // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
                ),
                // if (!(provider.data == null &&
                //     provider.filterParams == null &&
                //     provider.isLoading))
                //   HtmlTitle(
                //     subTitle: provider.extra?.subTitle ?? "",
                //     onFilterClick: _onFilterClick,
                //     hasFilter: provider.filterParams != null,
                //   ),
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
                    hasData: gainers != null && gainers.isNotEmpty,
                    isLoading: provider.isLoading,
                    errorDispCommon: true,
                    showPreparingText: true,
                    onRefresh: () => provider.getData(showProgress: true),
                    child: RefreshControl(
                      onRefresh: () async =>
                          provider.getData(showProgress: true),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async => provider.getData(loadMore: true),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: Dimen.padding,
                          top: Dimen.padding,
                        ),
                        itemBuilder: (context, index) {
                          return GainerLoserItem(
                            data: gainers![index],
                            index: index,
                            // marketData: true,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: ThemeColors.greyBorder,
                            height: 12.sp,
                          );
                        },
                        itemCount: gainers?.length ?? 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        MdBottomSheet(
          isFilter: provider.isFilterApplied(),
          isSort: provider.isSortingApplied(),
          onTapFilter: _onFilterClick,
          onTapSorting: () => onSortingClick(
            selected:
                context.read<TodayTopGainerProvider>().filterParams?.sorting,
            onTap: (sortingKey) {
              Navigator.pop(navigatorKey.currentContext!);
              context.read<TodayTopGainerProvider>().applySorting(sortingKey);
            },
            onResetClick: () {
              Navigator.pop(navigatorKey.currentContext!);
              context.read<TodayTopGainerProvider>().applySorting("");
            },
          ),
        )
      ],
    );
  }
}
