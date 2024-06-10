import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/dow_thirty_res.dart';
import 'package:stocks_news_new/providers/dow_30_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/html_title.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import 'item.dart';

class Dow30Stocks extends StatefulWidget {
  const Dow30Stocks({super.key});

  @override
  State<Dow30Stocks> createState() => _Dow30StocksState();
}

class _Dow30StocksState extends State<Dow30Stocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Dow30Provider provider = context.read<Dow30Provider>();
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
    context.read<Dow30Provider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    Dow30Provider provider = context.watch<Dow30Provider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlTitle(
          subTitle: provider.extra?.subTitle ?? "",
          onFilterClick: _onFilterClick,
          // margin: const EdgeInsets.only(top: 10, bottom: 10),
          hasFilter: provider.filterParams != null,
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
            hasData: !provider.isLoading && provider.data != null,
            isLoading: provider.isLoading,
            showPreparingText: true,
            errorDispCommon: true,
            onRefresh: () async => await provider.onRefresh(),
            child: RefreshControl(
              onRefresh: () async => await provider.onRefresh(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async => await provider.getData(loadMore: true),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  Result? data = provider.data?[index];
                  if (data == null) {
                    return const SizedBox();
                  }
                  return IndicesItem(data: data, index: index);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: ThemeColors.greyBorder,
                    height: 16,
                  );
                },
                itemCount: provider.data?.length ?? 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
