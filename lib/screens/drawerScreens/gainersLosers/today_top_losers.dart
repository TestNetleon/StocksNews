import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/today_top_loser_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../modals/gainers_losers_res.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../../moreStocks/topGainerLoser/item.dart';

class TodaysTopLoser extends StatefulWidget {
  const TodaysTopLoser({super.key});

  @override
  State<TodaysTopLoser> createState() => _TodaysTopLoserState();
}

class _TodaysTopLoserState extends State<TodaysTopLoser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TodayTopLoserProvider provider = context.read<TodayTopLoserProvider>();
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
        context.read<TodayTopLoserProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Today's Top Losers",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<TodayTopLoserProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    TodayTopLoserProvider provider = context.watch<TodayTopLoserProvider>();
    List<GainersLosersDataRes>? gainers = provider.data?.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarketDataHeader(
          provider: provider,
          onFilterClick: _onFilterClick,
          onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
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
            hasData: gainers != null && gainers.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getData(showProgress: true),
            child: RefreshControl(
              onRefresh: () async => provider.getData(showProgress: true),
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
                    marketData: true,
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
    );
  }
}
