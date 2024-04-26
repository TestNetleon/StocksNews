import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final String? optionalText;
  final bool canPopBack;
  final String? subTitle;
  const ScreenTitle({
    required this.title,
    this.style,
    super.key,
    this.optionalText,
    this.subTitle,
    this.canPopBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionalParent(
          addParent: optionalText != null,
          parentBuilder: (child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: style ?? styleGeorgiaBold(fontSize: 17),
                  ),
                ),
                Text(
                  optionalText ?? "",
                  style: style ?? stylePTSansRegular(fontSize: 12),
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
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 20.sp,
                      )),
                  Expanded(
                    child: Text(
                      title,
                      style: style ?? styleGeorgiaBold(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SpacerHorizontal(width: 20),
                ],
              );
            },
            child: Text(
              title,
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
              style:
                  stylePTSansRegular(fontSize: 14, color: ThemeColors.greyText),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimen.itemSpacing.sp),
          child: Divider(
            color: ThemeColors.accent,
            height: 2.sp,
            thickness: 2.sp,
          ),
        ),
      ],
    );
  }
}
