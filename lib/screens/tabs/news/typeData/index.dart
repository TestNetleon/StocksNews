import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../modals/home_insider_res.dart';
import '../../../../modals/news_res.dart';
import '../../../../providers/news_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/refresh_controll.dart';
import '../news_item.dart';

class NewsTypeData extends StatelessWidget {
  const NewsTypeData({super.key});

  @override
  Widget build(BuildContext context) {
    NewsCategoryProvider provider = context.watch<NewsCategoryProvider>();

    return RefreshControl(
      onRefresh: () async => provider.onRefresh(),
      canLoadMore: provider.canLoadMore,
      onLoadMore: () async => provider.onLoadMore(),
      child: ListView.separated(
        itemCount: provider.data?.length ?? 0,
        // shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 12.sp, top: 12.sp),
        itemBuilder: (context, index) {
          NewsData? newsItemData = provider.data?[index];
          if (index == 0) {
            return Column(
              children: [
                NewsItemSeparated(
                  showCategory: newsItemData?.authors?.isEmpty == true,
                  news: News(
                    slug: newsItemData?.slug,
                    // publishedDate: newsItemData.publishedDate,
                    title: newsItemData?.title ?? "",
                    image: newsItemData?.image ?? "",
                    site: newsItemData?.site ?? '',
                    authors: newsItemData?.authors,
                    postDate: DateFormat("MMMM dd, yyyy")
                        .format(newsItemData?.publishedDate ?? DateTime.now()),
                    url: newsItemData?.url,
                    //  "November 29, 2023",
                  ),
                ),
                // NewsItem(
                //   showCategory: newsItemData.authors?.isEmpty == true,
                //   news: News(
                //     slug: newsItemData.slug,
                //     // publishedDate: newsItemData.publishedDate,
                //     title: newsItemData.title,
                //     image: newsItemData.image,
                //     site: newsItemData.site ?? '',
                //     authors: newsItemData.authors,

                //     postDate: DateFormat("MMMM dd, yyyy")
                //         .format(newsItemData.publishedDate),
                //     url: newsItemData.url,
                //     //  "November 29, 2023",
                //   ),
                // ),
              ],
            );
          }

          return NewsItem(
            showCategory: newsItemData?.authors?.isEmpty == true,
            news: News(
              slug: newsItemData?.slug,
              // publishedDate: newsItemData.publishedDate,
              title: newsItemData?.title ?? "",
              image: newsItemData?.image ?? "",
              site: newsItemData?.site ?? '',
              authors: newsItemData?.authors,
              postDate: DateFormat("MMMM dd, yyyy")
                  .format(newsItemData?.publishedDate ?? DateTime.now()),
              url: newsItemData?.url,
              //  "November 29, 2023",
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          // return const SpacerVertical(height: 16);
          return Divider(
            color: ThemeColors.greyBorder,
            height: 20.sp,
          );
        },
      ),
    );
  }
}
