import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/blogs.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../widgets/custom/base_loader_container.dart';
import 'detail.dart';

class BlogsIndex extends StatefulWidget {
  static const path = 'BlogsIndex';
  const BlogsIndex({super.key});

  @override
  State<BlogsIndex> createState() => _BlogsIndexState();
}

class _BlogsIndexState extends State<BlogsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    BlogsManager manager = context.read<BlogsManager>();
    manager.getBlogsData(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    BlogsManager manager = context.watch<BlogsManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showSearch: true,
        showNotification: true,
      ),
      body: BaseLoaderContainer(
        hasData: manager.blogs != null,
        isLoading: manager.isLoading,
        error: manager.error,
        showPreparingText: true,
        child: BaseLoadMore(
          onLoadMore: () => _callAPI(loadMore: true),
          onRefresh: _callAPI,
          canLoadMore: manager.canLoadMoreStocks,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: Pad.pad16,
              vertical: Pad.pad16,
            ),
            itemBuilder: (context, index) {
              BaseNewsRes? data = manager.blogs?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return BaseNewsItem(
                data: data,
                onTap: (data) {
                  if (data.slug == null || data.slug == '') return;
                  // Navigator.pushNamed(
                  //   context,
                  //   BlogsDetailIndex.path,
                  //   arguments: {'slug': data.slug},
                  // );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BlogsDetailIndex(slug: data.slug ?? '')));
                },
              );
            },
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
            itemCount: manager.blogs?.data?.length ?? 0,
          ),
        ),
      ),
    );
  }
}
