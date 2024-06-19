import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/dividends_res.dart';
import 'package:stocks_news_new/providers/dividends_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/dividends/dividends_item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_title.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class DividendsList extends StatefulWidget {
  const DividendsList({super.key});

  @override
  State<DividendsList> createState() => _DividendsListState();
}

class _DividendsListState extends State<DividendsList> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (context.read<DividendsProvider>().data != null) {
  //       return;
  //     }
  //     context.read<DividendsProvider>().getDividendsStocks();
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DividendsProvider provider = context.read<DividendsProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getDividendsStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    DividendsProvider gapUpProvider = context.read<DividendsProvider>();

    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Dividend Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapUpProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<DividendsProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    DividendsProvider provider = context.watch<DividendsProvider>();
    List<DividendsRes>? data = provider.data;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Dimen.padding, right: Dimen.padding, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.data != null || provider.filterParams != null)
                MarketDataTitle(
                  htmlTitle: true,
                  title: provider.extra?.title,
                  subTitleHtml: true,
                  subTitle: provider.extra?.subTitle,
                  provider: provider,
                  // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
                  onFilterClick: _onFilterClick,
                ),
              // ScreenTitle(
              //   htmlTitle: true,
              //   title: provider.extraUp?.title ?? "Dividend Announcements",
              //   subTitleHtml: true,
              //   subTitle: provider.extraUp?.subTitle,
              // ),
              Expanded(
                child: BaseUiContainer(
                  error: provider.error,
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getDividendsStocks(),
                  child: RefreshControl(
                    onRefresh: () async => provider.getDividendsStocks(),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async =>
                        provider.getDividendsStocks(loadMore: true),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimen.padding,
                      ),
                      itemBuilder: (context, index) {
                        if (data == null || data.isEmpty) {
                          return const SizedBox();
                        }
                        return DividendsItem(data: data[index], index: index);
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
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MdBottomSheet(
            onTapFilter: _onFilterClick,
            onTapSorting: () => onSortingClick(
                selected:
                    context.read<DividendsProvider>().filterParams?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<DividendsProvider>().applySorting(sortingKey);
                }),
          ),
        )
      ],
    );
  }
}
