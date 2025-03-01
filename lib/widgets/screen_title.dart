import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ScreenTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? optionalText;
  final Widget? optionalWidget;
  final bool canPopBack;
  final String? subTitle;
  final bool divider;
  final bool htmlTitle;
  final EdgeInsets? dividerPadding;
  final bool subTitleHtml;
  final CrossAxisAlignment crossAxisAlignment;

  const ScreenTitle(
      {this.title,
      this.style,
      super.key,
      this.dividerPadding,
      this.optionalText,
      this.subTitle,
      this.canPopBack = false,
      this.divider = true,
      this.subTitleHtml = false,
      this.optionalWidget,
      this.htmlTitle = false,
      this.crossAxisAlignment = CrossAxisAlignment.end});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          OptionalParent(
            addParent: optionalText != null || optionalWidget != null,
            parentBuilder: (child) {
              return Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Expanded(
                    child: htmlTitle
                        ? HtmlWidget(
                            title ?? "",
                            textStyle: style ?? styleGeorgiaBold(fontSize: 25),
                          )
                        : Text(
                            title ?? "",
                            style: style ?? styleGeorgiaBold(fontSize: 25),
                          ),
                  ),
                  Visibility(
                    visible: optionalText != null,
                    child: Text(
                      optionalText ?? "",
                      style: style ?? stylePTSansRegular(fontSize: 12),
                    ),
                  ),
                  Visibility(
                    visible: optionalWidget != null,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp),
                      child: optionalWidget ?? const SizedBox(),
                    ),
                  ),
                ],
              );
            },
            child: OptionalParent(
              addParent: canPopBack,
              parentBuilder: (child) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title ?? "",
                        style: style ?? styleGeorgiaBold(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SpacerHorizontal(width: 20),
                  ],
                );
              },
              child: htmlTitle
                  ? HtmlWidget(
                      title ?? "",
                      textStyle: style ?? styleGeorgiaBold(fontSize: 25),
                    )
                  : Text(
                      title ?? "",
                      style: style ?? styleGeorgiaBold(fontSize: 25),
                    ),
            ),
          ),
        if (!isEmpty(subTitle))
          subTitleHtml
              ? HtmlWidget(
                  subTitle ?? "",
                  textStyle: stylePTSansRegular(
                    fontSize: 14,
                    color: ThemeColors.white,
                  ),
                  customWidgetBuilder: (element) {
                    return CustomReadMoreText(
                      text: element.text,
                      textColor: Colors.white,
                    );
                  },
                )
              : Visibility(
                  visible: subTitle != null,
                  child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: CustomReadMoreText(
                        text: subTitle ?? "",
                        textColor: Colors.white,
                      )),
                ),
        Padding(
          padding: dividerPadding ??
              const EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
          child: const SizedBox(),
        )
      ],
    );
  }
}
