import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/news_res.dart';
import 'package:stocks_news_new/providers/news_provider.dart';
import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<NewsProvider>().getNews(showProgress: true);
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "News - From Sources"},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    NewsProvider provider = context.watch<NewsProvider>();

    List<NewsData>? data = provider.data;

    return BaseUiContainer(
      // isLoading: provider.isLoading,
      isLoading: provider.isLoading,
      hasData: provider.data != null && provider.data!.isNotEmpty,
      error: provider.error,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () async => provider.getNews(showProgress: false),
      child: RefreshControl(
        onRefresh: () async => provider.getNews(showProgress: false),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getNews(loadMore: true),
        child: ListView.separated(
          itemCount: data?.length ?? 0,
          // shrinkWrap: true,
          // padding: EdgeInsets.all(12.sp),
          padding: EdgeInsets.only(bottom: 12.sp, top: 12.sp),
          itemBuilder: (context, index) {
            NewsData? newsItemData = data![index];
            if (index == 0) {
              return NewsItemSeparated(
                showCategory: newsItemData.authors?.isEmpty == true,
                news: News(
                  slug: newsItemData.slug,
                  // publishedDate: newsItemData.publishedDate,
                  title: newsItemData.title,
                  image: newsItemData.image,
                  site: newsItemData.site ?? '',
                  authors: newsItemData.authors,
                  postDateString: newsItemData.postDateString,
                  postDate: DateFormat("MMMM dd, yyyy")
                      .format(newsItemData.publishedDate),
                  url: newsItemData.url,
                  //  "November 29, 2023",
                ),
              );
            }

            return NewsItem(
              showCategory: newsItemData.authors?.isEmpty == true,
              news: News(
                slug: newsItemData.slug,
                // publishedDate: newsItemData.publishedDate,
                title: newsItemData.title,
                image: newsItemData.image,
                site: newsItemData.site ?? '',
                authors: newsItemData.authors,

                postDate: DateFormat("MMMM dd, yyyy")
                    .format(newsItemData.publishedDate),
                url: newsItemData.url,
                //  "November 29, 2023",
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
        ),
      ),
    );
  }
}
