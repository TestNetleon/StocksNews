import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/gap_up_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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
      // AmplitudeService.logUserInteractionEvent(type: "Gap Up Stocks");

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
    GapUpProvider gapUpProvider = context.read<GapUpProvider>();

    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Gap Up Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapUpProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<GapUpProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    GapUpProvider provider = context.watch<GapUpProvider>();
    List<GapUpRes>? data = provider.data;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Dimen.padding, right: Dimen.padding, bottom: 40),
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
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getGapUpStocks(),
                  child: SlidableAutoCloseBehavior(
                    child: RefreshControl(
                      onRefresh: () async => await provider.getGapUpStocks(),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          await provider.getGapUpStocks(loadMore: true),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: Dimen.padding,
                          top: 0,
                        ),
                        itemBuilder: (context, index) {
                          if (data == null || data.isEmpty) {
                            return const SizedBox();
                          }
                          return SlidableMenuWidget(
                              index: index,
                              alertForBullish:
                                  data[index].isAlertAdded?.toInt() ?? 0,
                              watlistForBullish:
                                  data[index].isWatchlistAdded?.toInt() ?? 0,
                              onClickAlert: () => _onAlertClick(
                                  context,
                                  data[index].symbol,
                                  data[index].name,
                                  data[index].isAlertAdded,
                                  index),
                              onClickWatchlist: () => _onWatchListClick(
                                  context,
                                  data[index].symbol,
                                  data[index].name,
                                  data[index].isWatchlistAdded,
                                  index),
                              child: UpDownStocksItem(
                                gapUp: true,
                                data: data[index],
                                isOpen: provider.openIndex == index,
                                onTap: () {
                                  provider.setOpenIndex(
                                    provider.openIndex == index ? -1 : index,
                                  );
                                },
                              ));
                          // return UpDownStocksItem(
                          //   gapUp: true,
                          //   data: data![index],
                          //   isOpen: provider.openIndex == index,
                          //   onTap: () {
                          //     provider.setOpenIndex(
                          //       provider.openIndex == index ? -1 : index,
                          //     );
                          //   },
                          // );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SpacerVertical(height: 12);
                        },
                        itemCount: data?.length ?? 0,
                      ),
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
            isFilter: provider.isFilterApplied(),
            isSort: provider.isSortingApplied(),
            onTapFilter: _onFilterClick,
            onTapSorting: () => onSortingClick(
              selected: context.read<GapUpProvider>().filterParams?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<GapUpProvider>().applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<GapUpProvider>().applySorting("");
              },
            ),
          ),
        )
      ],
    );
  }

  void _onAlertClick(
    BuildContext context,
    String symbol,
    String companyName,
    num? isAlertAdded,
    int? index,
  ) async {
    if ((isAlertAdded?.toInt() ?? 0) == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Alerts()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        showPlatformBottomSheet(
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          context: context,
          showClose: false,
          content: AlertPopup(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            symbol: symbol,
            companyName: companyName,
            index: index ?? 0,
            marketDataGapUp: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res = await context.read<GapUpProvider>().getGapUpStocks();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<GapUpProvider>()
                  .data?[index ?? 0]
                  .isAlertAdded ??
              0;
          if (alertOn == 0) {
            showPlatformBottomSheet(
              backgroundColor: const Color.fromARGB(255, 23, 23, 23),
              context: context,
              showClose: false,
              content: AlertPopup(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                symbol: symbol,
                companyName: companyName,
                index: index ?? 0,
                marketDataGapUp: true,
              ),
            );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const Alerts()),
            );
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void _onWatchListClick(
    BuildContext context,
    String symbol,
    String companyName,
    num? isWatchlistAdded,
    int index,
  ) async {
    if (isWatchlistAdded == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WatchList()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        await navigatorKey.currentContext!.read<GapUpProvider>().addToWishList(
              symbol: symbol,
              companyName: companyName,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<GapUpProvider>()
            .getGapUpStocks();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<GapUpProvider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<GapUpProvider>()
                .addToWishList(
                  symbol: symbol,
                  companyName: companyName,
                  index: index,
                  up: true,
                );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const WatchList()),
            );
          }
        }
      } catch (e) {
        //
      }
    }
  }
}
