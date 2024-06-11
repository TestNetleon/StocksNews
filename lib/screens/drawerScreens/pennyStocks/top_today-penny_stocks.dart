// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/providers/top_today_penny_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/pennyStocks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../providers/filter_provider.dart';
import '../../../utils/bottom_sheets.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../widget/market_data_filter.dart';

class TopTodayPennyStocks extends StatefulWidget {
  const TopTodayPennyStocks({super.key});

  @override
  State<TopTodayPennyStocks> createState() => _TopTodayPennyStocksState();
}

class _TopTodayPennyStocksState extends State<TopTodayPennyStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TopTodayPennyStocksProviders provider =
          context.read<TopTodayPennyStocksProviders>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData(type: 3);
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    TopTodayPennyStocksProviders todayTopProvider =
        context.read<TopTodayPennyStocksProviders>();

    if (provider.data == null) {
      await provider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Today's Top Penny Stock",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: todayTopProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<TopTodayPennyStocksProviders>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    TopTodayPennyStocksProviders provider =
        context.watch<TopTodayPennyStocksProviders>();
    List<PennyStocksRes>? data = provider.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarketDataHeader(
          provider: provider,
          onFilterClick: _onFilterClick,
          onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
        ),
        // HtmlTitle(
        //   subTitle: provider.extraUp?.subTitle ?? "",
        //   onFilterClick: _onFilterClick,
        //   margin: const EdgeInsets.only(top: 10, bottom: 10),
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
            onRefresh: () => provider.getData(type: 3),
            child: RefreshControl(
              onRefresh: () async => provider.getData(type: 3),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async => provider.getData(loadMore: true, type: 3),
              child: ListView.separated(
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
                ),
                itemBuilder: (context, index) {
                  if (data == null || data.isEmpty) {
                    return const SizedBox();
                  }

                  return PennyStocksItem(
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
