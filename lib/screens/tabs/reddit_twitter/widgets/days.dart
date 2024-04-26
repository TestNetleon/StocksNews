import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class RedditTwitterDays extends StatelessWidget {
  final BoxConstraints constraints;
  const RedditTwitterDays({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();

    return SizedBox(
      height: constraints.maxWidth * 0.1,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => provider.onDaysTap(
              index: index,
              days: provider.showTheLast[index].value,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Text(
                provider.showTheLast[index].name,
                style: stylePTSansRegular(
                  fontSize: 12,
                  color: provider.lastDayIndex == index
                      ? ThemeColors.accent
                      : Colors.white,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerHorizontal(width: 0);
        },
        itemCount: provider.showTheLast.length,
      ),
    );
  }
}
