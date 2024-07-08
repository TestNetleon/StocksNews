import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/earnings_res.dart';
import 'package:stocks_news_new/providers/earnings_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/marketData/earnings/earnings_item.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_title.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

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
      title: "Filter Earning Announcements",
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

    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions
            ?.any((element) => element == "earnings") ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions
              ?.any((element) => element == "earnings") ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

    // bool isLocked = false;

    // if (purchased) {
    //   bool havePermissions = userProvider.user?.membership?.permissions?.any(
    //           (element) =>
    //               element == "gap-up-stocks" || element == "gap-down-stocks") ??
    //       false;
    //   isLocked = !havePermissions;
    // } else {
    //   if (!isLocked) {
    //     isLocked = homeProvider.extra?.membership?.permissions?.any((element) =>
    //             element == "gap-up-stocks" || element == "gap-down-stocks") ??
    //         false;
    //   }
    // }

    // Utils().showLog("GAP UP DOWN OPEN? $isLocked");

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Dimen.padding,
            right: Dimen.padding,
            bottom: 40,
          ),
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
                      padding: const EdgeInsets.only(top: Dimen.padding),
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
                        return const SpacerVertical(height: 12);
                      },
                      itemCount: provider.data?.length ?? 0,
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
              selected: context.read<EarningsProvider>().filterParams?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<EarningsProvider>().applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<EarningsProvider>().applySorting("");
              },
            ),
          ),
        ),
        if (isLocked)
          CommonLock(
            showLogin: true,
            isLocked: isLocked,
          ),
      ],
    );
  }
}
