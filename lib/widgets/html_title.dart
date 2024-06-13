import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';

class HtmlTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? subTitle;
  final bool hasFilter;
  final EdgeInsets? margin;
  final Function()? onFilterClick;

  const HtmlTitle({
    this.title,
    this.style,
    super.key,
    this.subTitle,
    this.onFilterClick,
    this.margin,
    this.hasFilter = false,
  });
//
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: hasFilter
          ? const EdgeInsets.only(bottom: 0, top: 10)
          : const EdgeInsets.only(bottom: 10, top: 10),
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
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: HtmlWidget(subTitle ?? "",
                        customWidgetBuilder: (element) =>
                            CustomReadMoreText(text: element.text)
                        // ReadMoreText(
                        //   textAlign: TextAlign.start,
                        //   element.text,
                        //   trimLines: 2,
                        //   colorClickableText: ThemeColors.accent,
                        //   trimMode: TrimMode.Line,
                        //   trimCollapsedText: ' Read more',
                        //   trimExpandedText: ' Read less',
                        // moreStyle: stylePTSansRegular(
                        //   color: ThemeColors.accent,
                        //   fontSize: 12,
                        //   height: 1.3,
                        // ),
                        // style: stylePTSansRegular(
                        //   height: 1.3,
                        //   fontSize: 13,
                        //   color: ThemeColors.greyText,
                        // ),
                        // ),
                        // child:
                        // ReadMoreText(
                        //   textAlign: TextAlign.start,
                        //   subTitle ?? "",
                        //   trimLines: 2,
                        //   colorClickableText: ThemeColors.accent,
                        // trimMode: TrimMode.Line,
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
                ),
              ],
            ),
          ),
          Visibility(
            visible: onFilterClick != null,
            child: GestureDetector(
              onTap: onFilterClick,
              child: const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                child: Icon(Icons.filter_alt, color: ThemeColors.accent),
              ),
            ),
          )
        ],
      ),
    );
  }
}
