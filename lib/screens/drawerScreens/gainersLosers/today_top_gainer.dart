import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/today_top_gainer_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!(provider.data == null &&
            provider.filterParams == null &&
            provider.isLoading))
          HtmlTitle(
            subTitle: provider.extra?.subTitle ?? "",
            onFilterClick: _onFilterClick,
            margin: EdgeInsets.only(
              top: 10,
              bottom: provider.filterParams != null ? 0 : 10,
            ),
          ),
        if (provider.filterParams != null)
          FilterUiValues(
            params: provider.filterParams,
            onDeleteExchange: (exchange) {
              provider.exchangeFilter(exchange);
            },
          ),
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
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
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
