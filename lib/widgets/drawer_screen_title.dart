import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class DrawerScreenTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? subTitle;

  const DrawerScreenTitle({
    this.title,
    this.style,
    super.key,
    this.subTitle,
  });
//
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null && title != '',
          child: Container(
            margin: EdgeInsets.only(bottom: 5.sp),
            child: Text(
              title ?? "",
              style: style ?? stylePTSansRegular(fontSize: 13),
            ),
          ),
        ),
        Visibility(
          visible: subTitle != null && subTitle != "",
          child: Container(
            margin: EdgeInsets.only(bottom: 10.sp),
            // child: Text(
            //   subTitle ?? "",
            //   style: style ??
            //       stylePTSansRegular(fontSize: 14, color: ThemeColors.greyText),
            // ),
            child: ReadMoreText(
              textAlign: TextAlign.start,
              subTitle ?? "",
              trimLines: 2,
              colorClickableText: ThemeColors.accent,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' Read more',
              trimExpandedText: ' Read less',
              moreStyle: stylePTSansRegular(
                color: ThemeColors.accent,
                fontSize: 12,
                height: 1.0,
              ),
              style: stylePTSansRegular(
                height: 1.1,
                fontSize: 13,
                color: ThemeColors.greyText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
