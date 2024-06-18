import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/high_beta_stocks_providers.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class HighBetaStocks extends StatefulWidget {
  const HighBetaStocks({super.key});

  @override
  State<HighBetaStocks> createState() => _HighBetaStocksState();
}

class _HighBetaStocksState extends State<HighBetaStocks> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (context.read<HighBetaStocksProvider>().data != null) {
  //       return;
  //     }
  //     context.read<HighBetaStocksProvider>().getHighBetaStocks(type: 1);
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HighBetaStocksProvider provider = context.read<HighBetaStocksProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getHighBetaStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    HighBetaStocksProvider gapProvider = context.read<HighBetaStocksProvider>();
    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter High Beta Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<HighBetaStocksProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    HighBetaStocksProvider provider = context.watch<HighBetaStocksProvider>();
    List<HighLowBetaStocksRes>? data = provider.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarketDataHeader(
          provider: provider,
          onFilterClick: _onFilterClick,
          // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
        ),
        // HtmlTitle(
        //   subTitle: provider.extraUp?.subTitle ?? "",
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
            hasData: data != null && data.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getHighBetaStocks(type: 1),
            child: RefreshControl(
              onRefresh: () async => provider.getHighBetaStocks(type: 1),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async =>
                  provider.getHighBetaStocks(loadMore: true, type: 1),
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  bottom: Dimen.padding,
                  top: Dimen.padding,
                ),
                itemBuilder: (context, index) {
                  if (data == null || data.isEmpty) {
                    return const SizedBox();
                  }
                  return HighLowBetaStocksItem(
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
                  return Divider(
                    color: ThemeColors.greyBorder,
                    height: 20.sp,
                  );
                },
                itemCount: data?.length ?? 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
