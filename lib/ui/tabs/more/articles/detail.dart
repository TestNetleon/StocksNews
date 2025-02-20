import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/news/detail.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../../managers/blogs.dart';
import '../../../../utils/utils.dart';
import '../../../base/lock.dart';
import 'detail_data.dart';

class BlogsDetailIndex extends StatefulWidget {
  final String slug;
  static const path = 'BlogsDetailIndex';
  const BlogsDetailIndex({super.key, required this.slug});

  @override
  State<BlogsDetailIndex> createState() => _BlogsDetailIndexState();
}

class _BlogsDetailIndexState extends State<BlogsDetailIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({reset = true}) async {
    await context.read<BlogsManager>().getBlogsDetailData(
          widget.slug,
          reset: reset,
        );
  }

  @override
  Widget build(BuildContext context) {
    BlogsManager manager = context.watch<BlogsManager>();
    NewsPostDetailRes? postDetail = manager.blogsDetail?.postDetail;

    //Lock Condition

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
        hasData: manager.blogsDetail != null,
        isLoading: manager.isLoadingDetail,
        error: manager.errorDetail,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: Stack(
          children: [
            BlogDetailData(slug: widget.slug),
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
