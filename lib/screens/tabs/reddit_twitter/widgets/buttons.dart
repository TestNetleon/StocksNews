import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class RedditTwitterButtons extends StatelessWidget {
  final BoxConstraints constraints;
  const RedditTwitterButtons({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();

    return SizedBox(
      height: constraints.maxWidth * 0.1,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ThemeButtonSmall(
              onPressed: () => provider.onButtonTap(
                index: index,
                media: provider.buttons[index].value,
              ),
              showArrow: false,
              text: provider.buttons[index].name,
              textSize: 12,
              textColor: provider.buttonIndex == index
                  ? ThemeColors.border
                  : ThemeColors.background,
              color: provider.buttonIndex == index
                  ? ThemeColors.accent
                  : ThemeColors.border,
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerHorizontal(width: 10);
          },
          itemCount: provider.buttons.length),
    );
  }
}
