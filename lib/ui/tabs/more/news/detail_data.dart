import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/models/news/detail.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/AdManager/service.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:widget_zoom/widget_zoom.dart';
import '../../../../models/market/market_res.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/utils.dart';
import '../extra/feedback.dart';
import '../extra/tickers.dart';
import 'detail.dart';

class NewsDetailData extends StatelessWidget {
  final String slug;
  const NewsDetailData({super.key, required this.slug});

  Future _callAPI({reset = true}) async {
    await navigatorKey.currentContext!.read<NewsManager>().getNewsDetailData(
          slug,
          reset: reset,
        );
  }

  Future _sendFeedBack(MarketResData data) async {
    UserManager userManager = navigatorKey.currentContext!.read<UserManager>();

    await userManager.askLoginScreen();
    if (userManager.user == null) return;
    NewsManager manager = navigatorKey.currentContext!.read<NewsManager>();
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
    bool showAuthor =
        postDetail?.authors != null && postDetail?.authors?.isNotEmpty == true;
    bool showSite = postDetail?.site != null && postDetail?.site != '';
    bool showDate =
        postDetail?.publishedDate != null && postDetail?.publishedDate != '';

    return BaseScroll(
      onRefresh: () async {
        _callAPI(reset: false);
      },
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
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
        TickersBoxIndex(
            tickers: manager.newsDetail?.postDetail?.tickers,
            simulatorLockInfoRes: manager.newsDetail?.simulatorLockInfo),
        Padding(
          padding: const EdgeInsets.only(top: Pad.pad10),
          child: HtmlWidget(
            postDetail?.text ?? '',
            textStyle: styleBaseRegular(
              color: ThemeColors.black,
              fontSize: 18,
              height: 1.6,
            ),
            customWidgetBuilder: (element) {
              if (element.innerHtml.contains('DISPLAY_AD_1')) {
                return Visibility(
                  visible:
                      manager.newsDetail?.adManagers?.data?.newsPlace1 != null,
                  child: AdManagerIndex(
                    screen: AdScreen.newsDetail,
                    places: AdPlaces.place1,
                    margin: EdgeInsets.zero,
                    data: manager.newsDetail?.adManagers?.data?.newsPlace1,
                  ),
                );
              }

              if (element.innerHtml.contains('DISPLAY_AD_2')) {
                return Visibility(
                  visible:
                      manager.newsDetail?.adManagers?.data?.newsPlace2 != null,
                  child: AdManagerIndex(
                    screen: AdScreen.newsDetail,
                    places: AdPlaces.place2,
                    margin: EdgeInsets.zero,
                    data: manager.newsDetail?.adManagers?.data?.newsPlace2,
                  ),
                );
              }

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
        Visibility(
          visible: manager.newsDetail?.adManagers?.data?.newsPlace3 != null,
          child: AdManagerIndex(
            places: AdPlaces.place3,
            screen: AdScreen.newsDetail,
            margin: EdgeInsets.zero,
            data: manager.newsDetail?.adManagers?.data?.newsPlace3,
          ),
        ),
        FeedbackIndexItem(
          feedback: manager.newsDetail?.feedback,
          onTap: _sendFeedBack,
        ),
        Visibility(
          visible: manager.newsDetail?.moreNews != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerVertical(height: 20),
              BaseHeading(
                title: manager.newsDetail?.moreNews?.title,
              ),
              SpacerVertical(height: 10),
              Column(
                children: List.generate(
                  manager.newsDetail?.moreNews?.data?.length ?? 0,
                  (index) {
                    BaseNewsRes? data =
                        manager.newsDetail?.moreNews?.data?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return BaseNewsItem(
                      data: data,
                      onTap: (news) {
                        if (data.slug == null || data.slug == '') return;
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => NewsDetailIndex(
                        //               slug: data.slug ?? '',
                        //             )));
                        Navigator.pushReplacementNamed(
                            context, NewsDetailIndex.path,
                            arguments: {'slug': news.slug});
                      },
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
