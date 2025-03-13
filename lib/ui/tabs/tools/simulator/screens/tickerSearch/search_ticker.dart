import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/search.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tickerSearch/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class SearchTicker extends StatelessWidget {
  final SearchSymbolRes? symbolRes;
  final bool fromSearch;
  final Future<void> Function()? onRefresh;
  final void Function(BaseTickerRes)? stockClick;

  const SearchTicker({
    super.key,
    this.symbolRes,
    this.onRefresh,
    this.stockClick,
    this.fromSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    TickerSearchManager manager = context.watch<TickerSearchManager>();
    return BaseScroll(
      margin: EdgeInsets.zero,
      onRefresh: onRefresh,
      children: [
        if (manager.searchData == null &&
            manager.errorSearch != null &&
            !manager.isLoadingSearch)
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Pad.pad16),
                  decoration: BoxDecoration(
                    color: ThemeColors.neutral5,
                    borderRadius: BorderRadius.circular(Pad.pad16),
                  ),
                  child: Image.asset(
                    Images.search,
                    height: 56,
                    width: 56,
                  ),
                ),
                BaseHeading(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  title: 'No Results Found',
                  subtitle: manager.errorSearch,
                  textAlign: TextAlign.center,
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                ),
              ],
            ),
          ),
        Visibility(
          visible: symbolRes != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseHeading(
                title: symbolRes?.title,
                margin: EdgeInsets.symmetric(
                    horizontal: Pad.pad16, vertical: Pad.pad5),
                titleStyle:
                    styleBaseBold(color: ThemeColors.splashBG, fontSize: 24),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  BaseTickerRes? data = symbolRes?.data?[index];
                  if (data == null) {
                    return SizedBox();
                  }
                  return SdTradeDefaultItem(
                    data: data,
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: symbolRes?.data?.length ?? 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
