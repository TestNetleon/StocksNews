import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/gap_down_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/gapUpDown/item.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class GapDownStocks extends StatefulWidget {
  const GapDownStocks({super.key});

  @override
  State<GapDownStocks> createState() => _GapDownStocksState();
}

class _GapDownStocksState extends State<GapDownStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GapDownProvider provider = context.read<GapDownProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getGapDownStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    GapDownProvider gapProvider = context.read<GapDownProvider>();
    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Stock Screener",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<GapDownProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    GapDownProvider provider = context.watch<GapDownProvider>();
    List<GapUpRes>? data = provider.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlTitle(
          subTitle: provider.extra?.subTitle ?? "",
          onFilterClick: _onFilterClick,
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
            hasData: data != null && data.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getGapDownStocks(),
            child: RefreshControl(
              onRefresh: () async => provider.getGapDownStocks(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async => provider.getGapDownStocks(loadMore: true),
              child: ListView.separated(
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
                ),
                itemBuilder: (context, index) {
                  return UpDownStocksItem(
                    data: data![index],
                    isOpen: provider.openIndex == index,
                    onTap: () {
                      provider.setOpenIndex(
                        provider.openIndex == index ? -1 : index,
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: ThemeColors.greyBorder, height: 20.sp);
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
