import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/models/news/detail.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../../utils/utils.dart';
import '../../../base/lock.dart';
import 'detail_data.dart';

class NewsDetailIndex extends StatefulWidget {
  final String slug;
  static const path = 'NewsDetailIndex';
  const NewsDetailIndex({super.key, required this.slug});

  @override
  State<NewsDetailIndex> createState() => _NewsDetailIndexState();
}

class _NewsDetailIndexState extends State<NewsDetailIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({reset = true}) async {
    await context
        .read<NewsManager>()
        .getNewsDetailData(widget.slug, reset: reset);
  }

  @override
  Widget build(BuildContext context) {
    NewsManager manager = context.watch<NewsManager>();
    NewsPostDetailRes? postDetail = manager.newsDetail?.postDetail;

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showSearch: true,
        // showNotification: true,
        shareURL: postDetail?.shareUrl == null || postDetail?.shareUrl == ''
            ? null
            : () {
                commonShare(
                  title: postDetail?.title ?? "",
                  url: postDetail?.shareUrl ?? "",
                );
              },
      ),
      body: Stack(
        children: [
          BaseLoaderContainer(
            hasData: manager.newsDetail != null && !manager.isLoadingDetail,
            isLoading: manager.isLoadingDetail,
            error: manager.errorDetail,
            showPreparingText: true,
            onRefresh: _callAPI,
            child: NewsDetailData(slug: widget.slug),
          ),
          BaseLockItem(
            manager: manager,
            callAPI: _callAPI,
          ),
        ],
      ),
    );
  }
}
