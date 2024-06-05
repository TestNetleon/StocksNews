import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/simmer_effect_reddit_twitter.dart/days_sc_simmer.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/simmer_effect_reddit_twitter.dart/reddit_twitter_item_sc_simmer.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/screen_title_simmer.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class RedditTwitterScreenSimmer extends StatelessWidget {
  const RedditTwitterScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientContainerWidget(
            height: 400,
            borderRadius: 2.sp,
          ),
          const SpacerVertical(),
          GradientContainerWidget(
            height: 50,
            borderRadius: 2.sp,
          ),
          const SpacerVertical(height: 10),
          GradientContainerWidget(
            height: 20,
            borderRadius: 2.sp,
            width: 150.sp,
          ),
          const SpacerVertical(height: 10),
          const DaysScreenSimmer(),
          const RedditTwitterItemScreenSimmer(),
          const Divider(
            color: ThemeColors.greyBorder,
            height: 40,
          ),
          const ScreenTitleSimmer(),
          const RedditTwitterItemScreenSimmer(recentMentionData: true),
        ],
      ),
    );
  }
}
