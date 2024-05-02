import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_res.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/stocks/filter.dart';
import 'package:stocks_news_new/screens/stocks/item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';

//
class StocksContainer extends StatelessWidget {
  const StocksContainer({super.key});

  void _filterClick() {
    showPlatformBottomSheet(
        context: navigatorKey.currentContext!, content: const FilterStocks());
  }

  @override
  Widget build(BuildContext context) {
    AllStocksProvider provider = context.watch<AllStocksProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        filterClick: _filterClick,
        canSearch: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          children: [
            const ScreenTitle(title: "Stocks"),
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
                child: RefreshControll(
                  onRefresh: () => provider.getData(showProgress: true),
                  canLoadmore: provider.canLoadMore,
                  onLoadMore: () =>
                      provider.getData(loadMore: true, clear: false),
                  child: ListView.separated(
                    itemCount: provider.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    separatorBuilder: (context, index) {
                      // return const SpacerVertical(height: 10);
                      return Divider(
                        color: ThemeColors.greyBorder,
                        height: 12.sp,
                      );
                    },
                    itemBuilder: (context, index) {
                      AllStocks? data = provider.data?[index];
                      if (index == 0) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                      maxLines: 1,
                                      "COMPANY",
                                      style: stylePTSansRegular(
                                        fontSize: 12,
                                        color: ThemeColors.greyText,
                                      )),
                                ),
                                const SpacerHorizontal(width: 10),
                                // Expanded(
                                //   child: AutoSizeText(
                                //     maxLines: 1,
                                //     overflowReplacement: Text(
                                //       "EXChg.",
                                //       style: stylePTSansRegular(
                                //         fontSize: 12,
                                //         color: ThemeColors.greyText,
                                //       ),
                                //     ),
                                //     "EXCHANGE",
                                //     style: stylePTSansRegular(
                                //       fontSize: 12,
                                //       color: ThemeColors.greyText,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    "PRICE",
                                    style: stylePTSansRegular(
                                      fontSize: 12,
                                      color: ThemeColors.greyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SpacerVertical(height: Dimen.itemSpacing),
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
    );
  }
}
