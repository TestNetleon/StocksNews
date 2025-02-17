import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../managers/news.dart';
import '../../../../widgets/custom/base_loader_container.dart';

class NewsIndex extends StatelessWidget {
  final String id;
  const NewsIndex({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    NewsManager manager = context.watch<NewsManager>();
    HoldingNews? holdingNews = manager.newsData[id];

    bool canLoadMore =
        (holdingNews?.currentPage ?? 1) <= (holdingNews?.data?.totalPages ?? 1);
    if (holdingNews == null) {
      return SizedBox();
    }
    return BaseLoaderContainer(
      hasData: holdingNews.data != null,
      isLoading: holdingNews.loading,
      error: holdingNews.error,
      showPreparingText: true,
      child: BaseLoadMore(
        onLoadMore: manager.onLoadMore,
        onRefresh: manager.onRefresh,
        canLoadMore: canLoadMore,
        child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
            itemBuilder: (context, index) {
              BaseNewsRes? data = holdingNews.data?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return BaseNewsItem(data: data);
            },
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
            itemCount: holdingNews.data?.data?.length ?? 0),
      ),
    );
  }
}
