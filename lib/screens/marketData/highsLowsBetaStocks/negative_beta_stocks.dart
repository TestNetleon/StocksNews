import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/negative_beta_stocks_providers.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class NegativeBetaStocks extends StatefulWidget {
  const NegativeBetaStocks({super.key});

  @override
  State<NegativeBetaStocks> createState() => _NegativeBetaStocksState();
}

class _NegativeBetaStocksState extends State<NegativeBetaStocks> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (context.read<NegativeBetaStocksProvider>().data != null) {
  //       return;
  //     }
  //     context.read<NegativeBetaStocksProvider>().getNegativeBetaStocks(type: 3);
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NegativeBetaStocksProvider provider =
          context.read<NegativeBetaStocksProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getNegativeBetaStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    NegativeBetaStocksProvider gapProvider =
        context.read<NegativeBetaStocksProvider>();
    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Negative Beta Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<NegativeBetaStocksProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    NegativeBetaStocksProvider provider =
        context.watch<NegativeBetaStocksProvider>();
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
            onRefresh: () => provider.getNegativeBetaStocks(type: 3),
            child: RefreshControl(
              onRefresh: () async => provider.getNegativeBetaStocks(type: 3),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async =>
                  provider.getNegativeBetaStocks(loadMore: true, type: 3),
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
                // itemCount: up?.length ?? 0,
                itemCount: data?.length ?? 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
