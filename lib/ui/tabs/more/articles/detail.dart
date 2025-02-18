import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/models/news/detail.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:widget_zoom/widget_zoom.dart';
import '../../../../managers/blogs.dart';
import '../../../../models/market/market_res.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/utils.dart';
import '../extra/feedback.dart';
import '../extra/tickers.dart';

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

  Future _callAPI() async {
    await context.read<BlogsManager>().getBlogsDetailData(widget.slug);
  }

  Future _sendFeedBack(MarketResData data) async {
    UserManager userManager = context.read<UserManager>();

    await userManager.askLoginScreen();

    BlogsManager manager = context.read<BlogsManager>();
    await manager.sendFeedback(
      id: manager.blogsDetail?.postDetail?.id ?? '',
      type: data.slug ?? '',
      pageType: 'blog',
    );
  }

  @override
  Widget build(BuildContext context) {
    BlogsManager manager = context.watch<BlogsManager>();
    NewsPostDetailRes? postDetail = manager.blogsDetail?.postDetail;
    bool showAuthor =
        postDetail?.authors != null && postDetail?.authors?.isNotEmpty == true;
    bool showSite = postDetail?.site != null && postDetail?.site != '';
    bool showDate =
        postDetail?.publishedDate != null && postDetail?.publishedDate != '';

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
        hasData: manager.blogsDetail != null && !manager.isLoadingDetail,
        isLoading: manager.isLoadingDetail,
        error: manager.errorDetail,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: BaseScroll(
          onRefresh: _callAPI,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImagesWidget(postDetail?.image),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Pad.pad16),
              child: Text(
                postDetail?.title ?? '',
                style: styleBaseBold(fontSize: 29),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Pad.pad5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          if (showAuthor)
                            TextSpan(
                              text: postDetail?.authors?.first.name ?? '',
                              style: styleBaseRegular(
                                fontSize: 14,
                                color: ThemeColors.neutral80,
                              ),
                            ),
                          if (showAuthor && showDate)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.circle,
                                  size: 4,
                                  color: ThemeColors.neutral40,
                                ),
                              ),
                            ),
                          if (showDate)
                            TextSpan(
                              text: postDetail?.publishedDate ?? '',
                              style: styleBaseRegular(
                                fontSize: 14,
                                color: ThemeColors.neutral40,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showSite,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThemeColors.secondary10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        postDetail?.site ?? '',
                        style: styleBaseRegular(
                          fontSize: 14,
                          color: ThemeColors.secondary120,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TickersBoxIndex(tickers: manager.blogsDetail?.postDetail?.tickers),
            Padding(
              padding: const EdgeInsets.only(top: Pad.pad10),
              child: HtmlWidget(
                postDetail?.text ?? '',
                textStyle: styleBaseRegular(
                  color: ThemeColors.black,
                  fontSize: 18,
                ),
                customWidgetBuilder: (element) {
                  if (element.localName == 'img' &&
                      !(element.innerHtml.contains('DISPLAY_AD_1') ||
                          element.innerHtml.contains('DISPLAY_AD_2'))) {
                    final src = element.attributes['src'];
                    return WidgetZoom(
                      heroAnimationTag: '$src',
                      zoomWidget: Container(
                        color: ThemeColors.neutral10,
                        child: Image.network(
                          src ?? '',
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            Visibility(
              visible: postDetail?.uri != null && postDetail?.uri != '',
              child: GestureDetector(
                onTap: () {
                  openUrl(postDetail?.uri);
                },
                child: Text(
                  'Read full news..',
                  style: styleBaseRegular(
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ),
            FeedbackIndex(
              feedback: manager.blogsDetail?.feedback,
              onTap: _sendFeedBack,
            ),
            Visibility(
              visible: manager.blogsDetail?.moreNews != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseHeading(
                    title: manager.blogsDetail?.moreNews?.title,
                  ),
                  Column(
                    children: List.generate(
                      manager.blogsDetail?.moreNews?.data?.length ?? 0,
                      (index) {
                        BaseNewsRes? data =
                            manager.blogsDetail?.moreNews?.data?[index];
                        if (data == null) {
                          return SizedBox();
                        }
                        return BaseNewsItem(
                          data: data,
                          onTap: (news) {
                            if (data.slug == null || data.slug == '') return;
                            Navigator.pushReplacementNamed(
                                context, BlogsDetailIndex.path,
                                arguments: {'slug': data.slug});
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
