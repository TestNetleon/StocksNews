import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/ai_provider.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

import '../../../../modals/home_insider_res.dart';
import '../../../../modals/news_res.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/refresh_controll.dart';
import '../news_item.dart';

class AINewsIndex extends StatefulWidget {
  const AINewsIndex({super.key});

  @override
  State<AINewsIndex> createState() => _AINewsIndexState();
}

class _AINewsIndexState extends State<AINewsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AIProvider provider = context.read<AIProvider>();
      if (provider.data == null || provider.data?.isEmpty == true) {
        provider.getNews();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AIProvider provider = context.watch<AIProvider>();

    return BaseUiContainer(
      error: provider.error,
      hasData: provider.data != null && provider.data?.isNotEmpty == true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.onRefresh(),
      child: RefreshControl(
        onRefresh: () async => await provider.onRefresh(),
        // onRefresh: () async {
        //   log("message");
        // },
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.onLoadMore(),
        child: ListView.separated(
          itemCount: provider.data?.length ?? 0,
          padding: EdgeInsets.only(bottom: 12.sp, top: 0.sp),
          itemBuilder: (context, index) {
            NewsData? newsItemData = provider.data?[index];
            if (index == 0) {
              return NewsItemSeparated(
                fromAI: true,
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
              fromAI: true,
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
