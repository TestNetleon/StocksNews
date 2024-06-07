import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readmore/readmore.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class HtmlTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? subTitle;
  final EdgeInsets? margin;
  final Function()? onFilterClick;

  const HtmlTitle({
    this.title,
    this.style,
    super.key,
    this.subTitle,
    this.onFilterClick,
    this.margin,
  });
//
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
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
                  child: HtmlWidget(
                    subTitle ?? "",

                    customWidgetBuilder: (element) => ReadMoreText(
                      textAlign: TextAlign.start,
                      element.text,
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
                    // child: ReadMoreText(
                    //   textAlign: TextAlign.start,
                    //   subTitle ?? "",
                    //   trimLines: 2,
                    //   colorClickableText: ThemeColors.accent,
                    //   trimMode: TrimMode.Line,
                    //   trimCollapsedText: ' Read more',
                    //   trimExpandedText: ' Read less',
                    //   moreStyle: stylePTSansRegular(
                    //     color: ThemeColors.accent,
                    //     fontSize: 12,
                    //     height: 1.0,
                    //   ),
                    // style: stylePTSansRegular(
                    //   height: 1.1,
                    //   fontSize: 13,
                    //   color: ThemeColors.greyText,
                    // ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onFilterClick,
            child: const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
              child: Icon(
                Icons.filter_alt,
                color: ThemeColors.accent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
