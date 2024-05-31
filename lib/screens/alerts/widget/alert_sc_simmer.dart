import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/simmer_effect_reddit_twitter.dart/reddit_twitter_item_sc_simmer.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AlertScreenSimmer extends StatelessWidget {
  const AlertScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        GradientContainerWidget(
          height: 30,
          borderRadius: 2.sp,
        ),
        SpacerVertical(height: 5.sp),
        GradientContainerWidget(
          height: 50,
          borderRadius: 2.sp,
        ),
        SpacerVertical(height: 5.sp),
        GradientContainerWidget(
          height: 30,
          borderRadius: 2.sp,
        ),
        const RedditTwitterItemScreenSimmer(),
      ],
    ));
  }
}
