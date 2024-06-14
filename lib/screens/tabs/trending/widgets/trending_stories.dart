import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_stories_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TrendingStories extends StatelessWidget {
  const TrendingStories({super.key});
//
  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();
    TrendingRes? data = context.read<TrendingProvider>().trendingStories;

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Trending - Trending Stories"},
    );

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

        Visibility(
          visible: provider.mostBullish?.text?.generalNews != '',
          child: Padding(
              padding: EdgeInsets.only(bottom: 20.sp),
              child: CustomReadMoreText(
                text: provider.mostBullish?.text?.generalNews ?? "",
              )
              //  Text(
              //   provider.mostBullish?.text?.generalNews ?? "",
              //   style:
              //       stylePTSansRegular(fontSize: 13, color: ThemeColors.greyText),
              // ),
              ),
        ),

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
        if (provider.extra?.disclaimer != null &&
            (!provider.isLoadingStories &&
                (provider.trendingStories?.generalNews != null &&
                    provider.trendingStories?.generalNews?.isNotEmpty == true)))
          DisclaimerWidget(
            data: provider.extra!.disclaimer!,
          ),
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
