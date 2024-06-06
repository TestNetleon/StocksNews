import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class RedditTwitterButtons extends StatelessWidget {
  final BoxConstraints constraints;
  const RedditTwitterButtons({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();
//
    return SizedBox(
      height: constraints.maxWidth * 0.1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // return ThemeButtonSmall(
          //   onPressed: () => provider.onButtonTap(
          //     index: index,
          //     media: provider.buttons[index].value,
          //   ),
          //   showArrow: false,
          //   text: provider.buttons[index].name,
          //   textSize: 12,
          //   textColor: provider.buttonIndex == index
          //       ? ThemeColors.border
          //       : ThemeColors.background,
          //   color: provider.buttonIndex == index
          //       ? ThemeColors.accent
          //       : ThemeColors.border,
          //   padding: EdgeInsets.symmetric(horizontal: 12.sp),
          // );
          // return InkWell(
          //   onTap: () => provider.onButtonTap(
          //     index: index,
          //     media: provider.buttons[index].value,
          //   ),
          //   child: Center(
          //     child: Padding(
          //       padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
          //       child: Text(
          //         provider.buttons[index].name,
          //         style: stylePTSansRegular(
          //           fontSize: 12,
          //           color: provider.buttonIndex == index
          //               ? ThemeColors.accent
          //               : ThemeColors.border,
          //         ),
          //       ),
          //     ),
          //   ),
          // );
          return Center(
            child: Padding(
              padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
              child: Text(
                provider.buttons[index].name,
                style: stylePTSansRegular(
                  fontSize: 12,
                  color: ThemeColors.white,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerHorizontal(width: 10);
        },
        itemCount: provider.buttons.length,
      ),
    );
  }
}
