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

class FeaturedNewsList extends StatefulWidget {
  const FeaturedNewsList({super.key});

  @override
  State<FeaturedNewsList> createState() => _FeaturedNewsListState();
}

class _FeaturedNewsListState extends State<FeaturedNewsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<NewsProvider>().getNews(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    FeaturedNewsProvider provider = context.watch<FeaturedNewsProvider>();

    List<NewsData>? data = provider.data;

    return BaseUiContainer(
      // isLoading: provider.isLoading,
      isLoading: provider.isLoading,
      hasData: provider.data != null && provider.data!.isNotEmpty,
      error: provider.error,
      errorDispCommon: true,
      onRefresh: () async => provider.getNews(showProgress: false),
      child: RefreshControll(
        onRefresh: () async => provider.getNews(showProgress: false),
        canLoadmore: provider.canLoadMore,
        onLoadMore: () async => provider.getNews(loadMore: true),
        child: ListView.separated(
          itemCount: data?.length ?? 0,

          // shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 12.sp),
          itemBuilder: (context, index) {
            NewsData? newsItemData = data![index];
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
            // return const SpacerVerticel(height: 16);
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/home_insider_res.dart';
// import 'package:stocks_news_new/modals/news_res.dart';
// import 'package:stocks_news_new/providers/news_provider.dart';
// import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/refresh_controll.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// class FeaturedNewsList extends StatelessWidget {
//   const FeaturedNewsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     FeaturedNewsProvider provider = context.watch<FeaturedNewsProvider>();

//     List<NewsData>? data = provider.data;

//     return provider.tabLoading
//         ? Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 30.sp),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircularProgressIndicator(
//                     color: ThemeColors.accent,
//                   ),
//                   const SpacerHorizontal(width: 8),
//                   Flexible(
//                     child: Text(
//                       "loading your data.. Please wait.",
//                       style: stylePTSansRegular(fontSize: 13),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : RefreshControll(
//             onRefresh: () async =>
//                 provider.getNews(showProgress: false, tabChangeLoading: true),
//             canLoadmore: provider.canLoadMore,
//             onLoadMore: () async => provider.getNews(loadMore: true),
//             child: ListView.separated(
//               itemCount: data?.length ?? 0,
//               // shrinkWrap: true,
//               padding: EdgeInsets.only(bottom: 12.sp),
//               itemBuilder: (context, index) {
//                 NewsData? newsItemData = data![index];
//                 return NewsItem(
//                   showCategory: newsItemData.authors?.isEmpty == true,
//                   news: News(
//                     slug: newsItemData.slug,
//                     // publishedDate: newsItemData.publishedDate,
//                     title: newsItemData.title,
//                     image: newsItemData.image,
//                     site: newsItemData.site ?? '',
//                     authors: newsItemData.authors,

//                     postDate: DateFormat("MMMM dd, yyyy")
//                         .format(newsItemData.publishedDate),
//                     url: newsItemData.url,
//                     //  "November 29, 2023",
//                   ),
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 // return const SpacerVerticel(height: 16);
//                 return Divider(
//                   color: ThemeColors.greyBorder,
//                   height: 20.sp,
//                 );
//               },
//             ),
//           );
//   }
// }
