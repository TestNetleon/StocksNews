import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/top_search_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/stocks_item.dart';
import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SearchContainer extends StatelessWidget {
  static const String path = "Home";
  const SearchContainer({super.key});
//
  @override
  Widget build(BuildContext context) {
    SearchProvider provider = context.watch<SearchProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    return Column(
      children: [
        const SpacerVertical(),
        const ScreenTitle(title: "Top Searches"),
        ListView.separated(
          itemCount: provider.topSearch?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TopSearch topSearch = provider.topSearch![index];
            Top top = Top(
              name: topSearch.name,
              symbol: topSearch.symbol,
              price: topSearch.price,
              changesPercentage: topSearch.changes,
              image: topSearch.image,
              displayChange: "",
            );
            return StocksItem(
              top: top,
              gainer: true,
              priceData: false,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            // return const SpacerVertical(height: 12);
            return const Divider(
              height: 16,
              color: ThemeColors.greyBorder,
            );
          },
        ),
        const SpacerVertical(),
        const ScreenTitle(title: "Top News"),
        ListView.separated(
          itemCount: homeProvider.homeInsiderRes?.news.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            News? news = homeProvider.homeInsiderRes?.news[index];

            if (index == 0) {
              return NewsItemSeparated(
                showCategory: news?.authors?.isEmpty == true,
                news: news,
              );
            }

            return NewsItem(
                showCategory: news?.authors?.isEmpty == true, news: news);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
        )
      ],
    );
  }
}
