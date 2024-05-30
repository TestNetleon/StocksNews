import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';

import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ScreenTitleSimmer extends StatelessWidget {
  const ScreenTitleSimmer({
    super.key,
    this.optionalWidget,
    this.twoLineSubTitle = false,
    this.titleVisible = true,
    this.leftPaddingSubTitle = 10,
  });
  final bool? optionalWidget;
  final bool? twoLineSubTitle;
  final bool titleVisible;
  final double leftPaddingSubTitle;

//
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: titleVisible,
              child: GradientContainerWidget(
                height: 20,
                borderRadius: 2,
                width: 100.sp,
              ),
            ),
            Visibility(
              visible: optionalWidget != null,
              child: GradientContainerWidget(
                height: 30,
                borderRadius: 2,
                width: 30.sp,
              ),
            ),
          ],
        ),
        SpacerVertical(height: 5.sp),
        Padding(
          // padding: EdgeInsets.only(left: leftPaddingSubTitle.sp) ,
          padding: EdgeInsets.only(left: 0),
          child: GradientContainerWidget(
            height: twoLineSubTitle == true ? 40 : 18,
            borderRadius: 2.sp,
            width: twoLineSubTitle == true ? null : 200.sp,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
          child: Divider(
            color: ThemeColors.accent,
            height: 2,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
