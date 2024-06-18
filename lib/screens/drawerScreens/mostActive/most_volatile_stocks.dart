import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/most_volatile_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/mostActive/item.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostVolatileStocks extends StatefulWidget {
  const MostVolatileStocks({super.key});

  @override
  State<MostVolatileStocks> createState() => _MostVolatileStocksState();
}

class _MostVolatileStocksState extends State<MostVolatileStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MostVolatileStocksProvider provider =
          context.read<MostVolatileStocksProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData();
    });
  }

  void _onFilterClick() async {
    FilterProvider filterProvider = context.read<FilterProvider>();
    MostVolatileStocksProvider provider =
        context.read<MostVolatileStocksProvider>();
    if (filterProvider.data == null) {
      await filterProvider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Most Volatile Stock",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: provider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<MostVolatileStocksProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    MostVolatileStocksProvider provider =
        context.watch<MostVolatileStocksProvider>();
    List<MostActiveStocksRes>? data = provider.data;

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
        //   // margin: const EdgeInsets.only(top: 10, bottom: 10),
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
            onRefresh: () => provider.getData(type: 2),
            child: RefreshControl(
              onRefresh: () async => provider.getData(type: 2),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async => provider.getData(loadMore: true, type: 2),
              child: ListView.separated(
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
                ),
                itemBuilder: (context, index) {
                  if (data == null || data.isEmpty) {
                    return const SizedBox();
                  }
                  return MostActiveItem(
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
