import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/highlow_pe_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/high_pe_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import 'item.dart';

class HighPeStocks extends StatefulWidget {
  const HighPeStocks({super.key});

  @override
  State<HighPeStocks> createState() => _HighPeStocksState();
}

class _HighPeStocksState extends State<HighPeStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HighPeProvider provider = context.read<HighPeProvider>();
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
    FilteredParams? filterParams = context.read<HighPeProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter High PE Ratio Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<HighPeProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    HighPeProvider provider = context.watch<HighPeProvider>();

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
                  return Divider(color: ThemeColors.greyBorder, height: 20.sp);
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
