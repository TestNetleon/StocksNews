import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/simmer_effect_reddit_twitter.dart/reddit_twitter_item_sc_simmer.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeScreenSimmer extends StatelessWidget {
  const HomeScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpacerVertical(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GradientContainerWidget(
              height: 30,
              width: 100.sp,
            ),
            GradientContainerWidget(
              height: 30,
              width: 100.sp,
            ),
            GradientContainerWidget(
              height: 30,
              width: 100.sp,
            ),
          ],
        ),
        const SpacerVertical(),
        GradientContainerWidget(
          height: 20,
          width: 270.sp,
        ),
        const RedditTwitterItemScreenSimmer()
      ],
    );
  }
}
