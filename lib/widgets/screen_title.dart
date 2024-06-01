import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ScreenTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? optionalText;
  final Widget? optionalWidget;
  final bool canPopBack;
  final String? subTitle;
  final bool divider;
  final EdgeInsets? dividerPadding;

  const ScreenTitle({
    this.title,
    this.style,
    super.key,
    this.dividerPadding,
    this.optionalText,
    this.subTitle,
    this.canPopBack = false,
    this.divider = true,
    this.optionalWidget,
  });
//
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            OptionalParent(
              addParent: optionalText != null || optionalWidget != null,
              parentBuilder: (child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        title ?? "",
                        style: style ?? styleGeorgiaBold(fontSize: 17),
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
                          )),
                      Expanded(
                        child: Text(
                          title ?? "",
                          style: style ?? styleGeorgiaBold(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SpacerHorizontal(width: 20),
                    ],
                  );
                },
                child: Text(
                  title ?? "",
                  style: style ?? styleGeorgiaBold(fontSize: 17),
                ),
              ),
            ),
          Visibility(
            visible: subTitle != null,
            child: Container(
              margin: EdgeInsets.only(top: 3.sp),
              child: Text(
                subTitle ?? "",
                style: stylePTSansRegular(
                    fontSize: 14, color: ThemeColors.greyText),
              ),
            ),
          ),
          Visibility(
            visible: divider,
            child: Padding(
              padding: dividerPadding ??
                  const EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
              child: const Divider(
                color: ThemeColors.accent,
                height: 2,
                thickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
