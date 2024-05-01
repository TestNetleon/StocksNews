import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_stories_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingStories extends StatelessWidget {
  const TrendingStories({super.key});
//
  @override
  Widget build(BuildContext context) {
    // TrendingProvider provider = context.watch<TrendingProvider>();
    TrendingRes? data = context.read<TrendingProvider>().trendingStories;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ColoredText(
        //   text: "Trending Stories",
        //   coloredLetters: const ["S"],
        //   style: stylePTSansBold(),
        // ),
        // Text(
        //   "Trending Stories",
        //   style: stylePTSansBold(fontSize: 14),
        // ),
        // const SpacerVertical(),

        // const ScreenTitle(title: "Trending Stories"),
        ListView.separated(
          itemCount: data?.generalNews?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            GeneralNew newsItem = (data?.generalNews![index])!;
            return TrendingStoriesItem(data: newsItem);
            // return NewsItem(
            //     news: News(
            //   // authors: newsItem.authors,
            //   authors: [DetailListType(id: "1", name: "sss")],
            //   url: newsItem.url,
            //   title: newsItem.title ?? "",
            //   image: newsItem.image ?? "",
            //   site: newsItem.site ?? "",
            //   postDate: DateFormat("MMMM dd, yyyy").format(
            //     newsItem.publishedDate ?? DateTime.now(),
            //   ),
            // ));
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
            // return const SpacerVertical(height: 12);
          },
        ),
        const SpacerVertical(height: Dimen.itemSpacing),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: ThemeButtonSmall(
        //     onPressed: () {},
        //     text: "View All",
        //   ),
        // )
      ],
    );
  }
}
