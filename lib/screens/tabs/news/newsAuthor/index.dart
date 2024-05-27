import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/modals/news_res.dart';
import 'package:stocks_news_new/providers/news_provider.dart';
import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
//
import '../../home/widgets/app_bar_home.dart';

class NewsAuthorIndex extends StatelessWidget {
  final BlogsType type;
  final DetailListType? data;
  static const path = "NewsAuthorIndex";
  const NewsAuthorIndex({
    super.key,
    this.data,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(canSearch: true, isPopback: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          children: [
            // const NewsHeaderStocks(),
            ScreenTitle(
                title: type == BlogsType.author
                    ? "Articles by ${data?.name}"
                    : "News Under - ${data?.name}"),
            Expanded(child: NewsAuthorContainer(type: type, data: data)),
          ],
        ),
      ),
    );
  }
}

class NewsAuthorContainer extends StatefulWidget {
  final BlogsType type;
  final DetailListType? data;

  const NewsAuthorContainer({super.key, required this.type, this.data});

  @override
  State<NewsAuthorContainer> createState() => _NewsAuthorContainerState();
}

class _NewsAuthorContainerState extends State<NewsAuthorContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI(showProgress: true);
    });
  }

  Future _callAPI({showProgress = false, loadMore = false}) async {
    await context.read<NewsTypeProvider>().getNewsTypeData(
          showProgress: showProgress,
          type: widget.type,
          id: widget.data?.id,
          loadMore: loadMore,
        );
  }

  @override
  Widget build(BuildContext context) {
    NewsTypeProvider provider = context.watch<NewsTypeProvider>();
    return BaseUiContainer(
      isLoading: provider.isLoading && provider.data == null,
      hasData: provider.data != null && provider.data!.isNotEmpty,
      error: provider.error,
      errorDispCommon: true,
      onRefresh: () async => _callAPI(showProgress: true),
      child: RefreshControl(
          onRefresh: () async => _callAPI(showProgress: true),
          canLoadMore: provider.canLoadMore,
          onLoadMore: () async => _callAPI(loadMore: true),
          child: ListView.separated(
            itemCount: provider.data?.length ?? 0,
            // shrinkWrap: true,
            // padding: EdgeInsets.all(12.sp),
            itemBuilder: (context, index) {
              NewsData? newsItemData = provider.data?[index];
              if (newsItemData == null) {
                return const SizedBox();
              }
              if (index == 0) {
                return NewsItemSeparated(
                  showCategory: newsItemData.authors?.isEmpty == true,
                  // showCategory: false,
                  news: News(
                      slug: newsItemData.slug,
                      // publishedDate: newsItemData.publishedDate,
                      title: newsItemData.title,
                      image: newsItemData.image,
                      site: newsItemData.site ?? '',
                      postDate: DateFormat("MMMM dd, yyyy")
                          .format(newsItemData.publishedDate),
                      url: newsItemData.url,
                      authors: newsItemData.authors
                      //  "November 29, 2023",
                      ),
                );
              }

              return NewsItem(
                showCategory: newsItemData.authors?.isEmpty == true,
                // showCategory: false,
                news: News(
                    slug: newsItemData.slug,
                    // publishedDate: newsItemData.publishedDate,
                    title: newsItemData.title,
                    image: newsItemData.image,
                    site: newsItemData.site ?? '',
                    postDate: DateFormat("MMMM dd, yyyy")
                        .format(newsItemData.publishedDate),
                    url: newsItemData.url,
                    authors: newsItemData.authors
                    //  "November 29, 2023",
                    ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: ThemeColors.greyBorder,
                height: 16.sp,
              );
            },
          )),
    );
  }
}
