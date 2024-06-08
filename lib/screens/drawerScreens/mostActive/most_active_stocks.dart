import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/most_active_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostActiveStocks extends StatefulWidget {
  const MostActiveStocks({super.key});

  @override
  State<MostActiveStocks> createState() => _MostActiveStocksState();
}

class _MostActiveStocksState extends State<MostActiveStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MostActiveProvider provider = context.read<MostActiveProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Stock Screener",
      child: MarketDataFilterBottomSheet(onFiltered: _onFiltered),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<MostActiveProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    MostActiveProvider provider = context.watch<MostActiveProvider>();
    List<MostActiveStocksRes>? data = provider.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlTitle(
          subTitle: provider.extraUp?.subTitle ?? "",
          onFilterClick: _onFilterClick,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
        ),
        if (provider.filterParams != null)
          FilterUiValues(
            params: provider.filterParams,
            onDeleteExchange: (exchange) {
              provider.exchangeFilter(exchange);
            },
          ),
        BaseUiContainer(
          error: provider.error,
          hasData: data != null && data.isNotEmpty,
          isLoading: provider.isLoading,
          errorDispCommon: true,
          showPreparingText: true,
          onRefresh: () => provider.getData(type: 1),
          child: RefreshControl(
            onRefresh: () async => provider.getData(type: 1),
            canLoadMore: provider.canLoadMore,
            onLoadMore: () async => provider.getData(loadMore: true, type: 1),
            child: ListView.separated(
              padding: EdgeInsets.only(
                bottom: Dimen.padding.sp,
                top: Dimen.padding.sp,
              ),
              itemBuilder: (context, index) {
                if (data == null || data.isEmpty) {
                  return const SizedBox();
                }
                return const SizedBox();

                // return MostActiveItem(
                //   data: data[index],
                //   index: index,
                // );
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
      ],
    );
  }
}
