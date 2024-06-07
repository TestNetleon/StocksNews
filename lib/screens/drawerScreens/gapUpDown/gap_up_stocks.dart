import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/gap_up_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/gapUpDown/item.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class GapUpStocks extends StatefulWidget {
  const GapUpStocks({super.key});

  @override
  State<GapUpStocks> createState() => _GapUpStocksState();
}

class _GapUpStocksState extends State<GapUpStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GapUpProvider provider = context.read<GapUpProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getGapUpStocks();
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
    context.read<GapUpProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    GapUpProvider provider = context.watch<GapUpProvider>();
    List<GapUpRes>? data = provider.data;

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
            hasData: data != null && data.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getGapUpStocks(),
            child: RefreshControl(
              onRefresh: () async => provider.getGapUpStocks(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async => provider.getGapUpStocks(loadMore: true),
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
