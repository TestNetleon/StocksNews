import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_res.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/stocks/filter.dart';
import 'package:stocks_news_new/screens/stocks/item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';
import '../../providers/user_provider.dart';

//
class StocksContainer extends StatelessWidget {
  const StocksContainer({super.key});

  // void _filterClick() {
  //   showPlatformBottomSheet(
  //       padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
  //       context: navigatorKey.currentContext!,
  //       content: const FilterStocks());
  // }

  void _filterClick() {
    BaseBottomSheets().gradientBottomSheet(
        title: "Filter Stocks", child: const FilterStocks());
  }

  @override
  Widget build(BuildContext context) {
    AllStocksProvider provider = context.watch<AllStocksProvider>();

    UserProvider userProvider = context.watch<UserProvider>();
    // HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = provider.extra?.membership?.permissions?.any(
            (element) => (element.key == "stocks" && element.status == 0)) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) => (element.key == "stocks" && element.status == 1)) ??
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
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        filterClick: _filterClick,
        canSearch: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimen.padding.sp,
              0,
              Dimen.padding.sp,
              0,
            ),
            child: Column(
              children: [
                ScreenTitle(
                  title: "Stocks",
                  subTitle: provider.textRes?.subTitle,
                  dividerPadding: const EdgeInsets.only(bottom: 12),
                  optionalWidget: GestureDetector(
                    onTap: _filterClick,
                    child: const Icon(
                      Icons.filter_alt,
                      color: ThemeColors.accent,
                    ),
                  ),
                ),
                TextInputFieldSearch(
                  hintText: "Search by symbol or company name",
                  onSubmitted: (text) {
                    closeKeyboard();
                    provider.getData(search: text, clear: false);
                  },
                  searching: provider.isSearching,
                  editable: true,
                ),
                Expanded(
                  child: BaseUiContainer(
                    isLoading: provider.isLoading,
                    hasData: provider.data != null &&
                        (provider.data?.isNotEmpty ?? false) &&
                        !provider.isLoading,
                    error: provider.error,
                    showPreparingText: true,
                    child: RefreshControl(
                      onRefresh: () async =>
                          provider.getData(showProgress: false),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          provider.getData(loadMore: true, clear: false),
                      child: ListView.separated(
                        itemCount: provider.data?.length ?? 0,
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        separatorBuilder: (context, index) {
                          return const SpacerVertical(height: 12);
                        },
                        itemBuilder: (context, index) {
                          AllStocks? data = provider.data?[index];
                          if (index == 0) {
                            return Column(
                              children: [
                                Divider(
                                  color: ThemeColors.greyBorder,
                                  height: 15.sp,
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    const SpacerHorizontal(width: 5),
                                    Expanded(
                                      child: AutoSizeText(
                                        maxLines: 1,
                                        "COMPANY",
                                        style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: ThemeColors.greyText,
                                        ),
                                      ),
                                    ),
                                    const SpacerHorizontal(width: 24),
                                    AutoSizeText(
                                      maxLines: 1,
                                      "PRICE",
                                      style: stylePTSansRegular(
                                        fontSize: 12,
                                        color: ThemeColors.greyText,
                                      ),
                                    ),
                                    const SpacerHorizontal(width: 52),
                                  ],
                                ),
                                Divider(
                                  color: ThemeColors.greyBorder,
                                  height: 15.sp,
                                  thickness: 1,
                                ),
                                StocksItemAll(data: data, index: index),
                              ],
                            );
                          }
                          return StocksItemAll(
                            index: index,
                            data: data,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLocked)
            CommonLock(
              showLogin: true,
              isLocked: isLocked,
            ),
        ],
      ),
    );
  }
}
