import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/search.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import 'package:stocks_news_new/ui/base/stock/slidable_add.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../managers/search.dart';
import '../../../models/news.dart';
import '../../../widgets/cache_network_image.dart';

class BaseSearchData extends StatelessWidget {
  final SearchSymbolRes? symbolRes;
  final SearchNewsRes? newsRes;
  final bool fromSearch;
  final Future<void> Function()? onRefresh;
  final void Function(BaseTickerRes)? stockClick;
  final void Function(BaseNewsRes)? newsClick;

  const BaseSearchData({
    super.key,
    this.symbolRes,
    this.newsRes,
    this.onRefresh,
    this.stockClick,
    this.newsClick,
    this.fromSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    SearchManager manager = context.watch<SearchManager>();

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
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  BaseTickerRes? data = symbolRes?.data?[index];
                  if (data == null) {
                    return SizedBox();
                  }
                  return SlidableStockAddItem(
                    onTap: stockClick,
                    data: data,
                    index: index,
                    slidable: false,
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
        Visibility(
          visible: newsRes != null && !fromSearch,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseHeading(
                title: newsRes?.title,
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: Pad.pad16,
                  vertical: Pad.pad16,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  BaseNewsRes? data = newsRes?.data?[index];
                  if (data == null) {
                    return SizedBox();
                  }
                  return BaseNewsItem(
                    data: data,
                    onTap: newsClick,
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: newsRes?.data?.length ?? 0,
              ),
            ],
          ),
        ),
        Visibility(
          visible: newsRes != null && fromSearch,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseHeading(
                title: newsRes?.title,
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: Pad.pad16,
                ),
                itemBuilder: (context, index) {
                  BaseNewsRes? data = newsRes?.data?[index];
                  if (data == null) {
                    return SizedBox();
                  }
                  return GestureDetector(
                    onTap: () {
                      if (data.slug == null || data.slug == '') return;
                      Navigator.pushNamed(context, NewsDetailIndex.path,
                          arguments: {
                            'slug': data.slug,
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: Pad.pad10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              data.title ?? '',
                              style: styleBaseRegular(fontSize: 14),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 100,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImagesWidget(data.image),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: newsRes?.data?.length ?? 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
