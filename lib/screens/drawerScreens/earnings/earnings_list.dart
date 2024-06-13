import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/earnings_res.dart';
import 'package:stocks_news_new/providers/earnings_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/earnings/earnings_item.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_title.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

class EarningsList extends StatefulWidget {
  const EarningsList({super.key});

  @override
  State<EarningsList> createState() => _EarningsListState();
}

class _EarningsListState extends State<EarningsList> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (context.read<EarningsProvider>().data != null) {
  //       return;
  //     }
  //     context.read<EarningsProvider>().getEarningsStocks();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      EarningsProvider provider = context.read<EarningsProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getEarningsStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    EarningsProvider gapUpProvider = context.read<EarningsProvider>();

    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Earning Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapUpProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<EarningsProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    EarningsProvider provider = context.watch<EarningsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (provider.data != null || provider.filterParams != null)
          MarketDataTitle(
            htmlTitle: true,
            title: provider.extra?.title,
            subTitleHtml: true,
            subTitle: provider.extra?.subTitle,
            provider: provider,
            onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
            onFilterClick: _onFilterClick,
          ),
        Expanded(
          child: BaseUiContainer(
            error: provider.error,
            hasData: provider.data != null && provider.data!.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getEarningsStocks(),
            child: RefreshControl(
              onRefresh: () async => provider.getEarningsStocks(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async =>
                  provider.getEarningsStocks(loadMore: true),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimen.padding,
                ),
                itemBuilder: (context, index) {
                  if (provider.data == null || provider.data!.isEmpty) {
                    return const SizedBox();
                  }
                  EarningsRes dataItem = provider.data![index];
                  return EarningsItem(
                    data: dataItem,
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
                itemCount: provider.data?.length ?? 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
