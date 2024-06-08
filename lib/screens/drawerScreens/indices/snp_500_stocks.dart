import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/dow_thirty_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/snp_500_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/html_title.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import 'item.dart';

class Snp500Stocks extends StatefulWidget {
  const Snp500Stocks({super.key});

  @override
  State<Snp500Stocks> createState() => _Snp500StocksState();
}

class _Snp500StocksState extends State<Snp500Stocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SnP500Provider provider = context.read<SnP500Provider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData();
    });
  }

  void _onFilterClick() async {
    FilterProvider filterProvider = context.read<FilterProvider>();
    SnP500Provider provider = context.read<SnP500Provider>();
    if (filterProvider.data == null) {
      await filterProvider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Stock Screener",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: provider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<SnP500Provider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    SnP500Provider provider = context.watch<SnP500Provider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlTitle(
          subTitle: provider.extra?.subTitle ?? "",
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
                padding: EdgeInsets.symmetric(vertical: 10.sp),
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
