import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class RedditCommentItem extends StatelessWidget {
  final int index;
  final RedditPost redditPost;
  const RedditCommentItem(
      {super.key, required this.index, required this.redditPost});
//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeColors.primary,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: ThemeColors.greyBorder)),
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    "${redditPost.subredditNamePrefixed} ",
                    style: stylePTSansBold(fontSize: 13),
                  ),
                  Icon(
                    Icons.circle,
                    size: 6.sp,
                  ),
                  Text(
                    " Commented 18 mins ago",
                    style: stylePTSansRegular(fontSize: 13),
                  ),
                ],
              )

                  //  RichText(
                  //   text: TextSpan(
                  //     text: "${redditPost.subredditNamePrefixed} . ",
                  //     style: stylePTSansBold(fontSize: 13),
                  //     children: [
                  //       TextSpan(
                  //         text: "Commented 18 mins ago",
                  //         style: stylePTSansRegular(fontSize: 13),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  ),
              const SpacerHorizontal(width: 5),
              Image.asset(
                Images.reddit,
                height: 23.sp,
                width: 23.sp,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.sp),
              decoration: BoxDecoration(
                  color: ThemeColors.greyText.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3.sp)),
              child: Text(
                redditPost.text,
                style: stylePTSansRegular(fontSize: 13),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: "In ",
              style: stylePTSansRegular(fontSize: 13),
              children: [
                TextSpan(
                  text: redditPost.subredditNamePrefixed,
                  style: stylePTSansBold(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
