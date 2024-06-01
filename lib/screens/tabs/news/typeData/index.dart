import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/news_tab_category_res.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

import '../../../../modals/home_insider_res.dart';
import '../../../../modals/news_res.dart';
import '../../../../providers/news_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/refresh_controll.dart';
import '../news_item.dart';

class NewsTypeData extends StatelessWidget {
  final String id;

  const NewsTypeData({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    NewsCategoryProvider provider = context.watch<NewsCategoryProvider>();
    TabsNewsHolder? newsHolder = provider.newsData[id];

    return BaseUiContainer(
      error: newsHolder?.error,
      hasData: newsHolder?.data != null &&
          (newsHolder?.data?.data.isNotEmpty ?? false),
      isLoading: newsHolder?.loading ?? true,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.onRefresh(),
      child: RefreshControl(
        onRefresh: () async => await provider.onRefresh(),
        // onRefresh: () async {
        //   log("message");
        // },

        canLoadMore:
            (newsHolder?.currentPage ?? 1) < (newsHolder?.data?.lastPage ?? 1),
        onLoadMore: () async => provider.onLoadMore(),
        child: ListView.separated(
          itemCount: newsHolder?.data?.data.length ?? 0,
          padding: EdgeInsets.only(bottom: 12.sp, top: 12.sp),
          itemBuilder: (context, index) {
            NewsData? newsItemData = newsHolder?.data?.data[index];
            if (index == 0) {
              return NewsItemSeparated(
                showCategory: newsItemData?.authors?.isEmpty == true,
                news: News(
                  slug: newsItemData?.slug,
                  title: newsItemData?.title ?? "",
                  image: newsItemData?.image ?? "",
                  site: newsItemData?.site ?? '',
                  authors: newsItemData?.authors,
                  postDate: DateFormat("MMMM dd, yyyy").format(
                    newsItemData?.publishedDate ?? DateTime.now(),
                  ),
                  postDateString: newsItemData?.postDateString,
                  url: newsItemData?.url,
                ),
              );
            }
            return NewsItem(
              showCategory: newsItemData?.authors?.isEmpty == true,
              news: News(
                slug: newsItemData?.slug,
                title: newsItemData?.title ?? "",
                image: newsItemData?.image ?? "",
                site: newsItemData?.site ?? '',
                authors: newsItemData?.authors,
                postDateString: newsItemData?.postDateString,
                postDate: DateFormat("MMMM dd, yyyy")
                    .format(newsItemData?.publishedDate ?? DateTime.now()),
                url: newsItemData?.url,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: ThemeColors.greyBorder, height: 20.sp);
          },
        ),
      ),
    );
  }
}
