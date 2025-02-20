import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/news/detail.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../../models/market/market_res.dart';
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

  Future _callAPI() async {
    await context.read<NewsManager>().getNewsDetailData(widget.slug);
  }

  Future _sendFeedBack(MarketResData data) async {
    UserManager userManager = context.read<UserManager>();

    await userManager.askLoginScreen();

    NewsManager manager = context.read<NewsManager>();
    await manager.sendFeedback(
      id: manager.newsDetail?.postDetail?.id ?? '',
      type: data.slug ?? '',
      pageType: 'news',
    );
  }

  @override
  Widget build(BuildContext context) {
    NewsManager manager = context.watch<NewsManager>();
    NewsPostDetailRes? postDetail = manager.newsDetail?.postDetail;

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showLogo: false,
        showSearch: true,
        shareURL: postDetail?.shareUrl == null || postDetail?.shareUrl == ''
            ? null
            : () {
                commonShare(
                  title: postDetail?.title ?? "",
                  url: postDetail?.shareUrl ?? "",
                );
              },
      ),
      body: BaseLoaderContainer(
        hasData: manager.newsDetail != null && !manager.isLoadingDetail,
        isLoading: manager.isLoadingDetail,
        error: manager.errorDetail,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: Stack(
          children: [
            NewsDetailData(slug: widget.slug),
            BaseLockItem(
              manager: manager,
              callAPI: _callAPI,
            ),
          ],
        ),
      ),
    );
  }
}
