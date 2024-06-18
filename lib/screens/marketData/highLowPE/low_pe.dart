import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/low_pe_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../modals/highlow_pe_res.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class LowPEStocks extends StatefulWidget {
  const LowPEStocks({super.key});

  @override
  State<LowPEStocks> createState() => _LowPEStocksState();
}

class _LowPEStocksState extends State<LowPEStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LowPeProvider provider = context.read<LowPeProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData(showProgress: true);
      //-------
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    FilteredParams? filterParams = context.read<LowPeProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Low PE Ratio Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<LowPeProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    LowPeProvider provider = context.watch<LowPeProvider>();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimen.padding,
          ),
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
                        HIghLowPeRes? low = provider.data?[index];
                        return HighLowPEItem(
                          index: index,
                          data: low,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: ThemeColors.greyBorder,
                          height: 20.sp,
                        );
                      },
                      // itemCount: up?.length ?? 0,
                      itemCount: provider.data?.length ?? 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Align( 6/18/2024
        //     alignment: Alignment.bottomCenter,
        //     child: MdBottomSheet(
        //       onTapFilter: _onFilterClick,
        //       onTapSorting: () => onSortingClick(onTap: (sortingKey) {
        //         Navigator.pop(navigatorKey.currentContext!);
        //         context.read<LowPeProvider>().applySorting(sortingKey);
        //       }),
        //     ))
      ],
    );
  }
}
