import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class HomeNewsItem extends StatelessWidget {
  const HomeNewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
//
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(
        //   "News",
        //   style: styleGeorgiaBold(fontSize: 22),
        // ),
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 8.sp),
        //   child: Divider(
        //     color: ThemeColors.accent,
        //     height: 2.sp,
        //     thickness: 2.sp,
        //   ),
        // ),

        const ScreenTitle(
          title: "Stock Market News",
        ),
        ListView.separated(
          itemCount: provider.homeInsiderRes!.news.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 12.sp),
          itemBuilder: (context, index) {
            News news = provider.homeInsiderRes!.news[index];
            return NewsItem(
              news: news,
              showCategory: news.authors?.isEmpty == true,
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
        const SpacerVerticel(height: Dimen.itemSpacing),
        Align(
          alignment: Alignment.centerLeft,
          child: ThemeButtonSmall(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Tabs(index: 4)),
              );
            },
            text: "View More",
          ),
        )
      ],
    );
  }
}
