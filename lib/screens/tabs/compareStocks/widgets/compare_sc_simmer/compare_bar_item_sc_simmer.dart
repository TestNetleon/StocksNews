import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class CompareBarItemScreenSimmer extends StatelessWidget {
  const CompareBarItemScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientContainerWidget(
          height: 14.sp,
          width: 50.sp,
          borderRadius: 2.sp,
        ),
        SpacerHorizontal(width: 22.sp),
        GradientContainerWidget(
          height: 14.sp,
          width: 100.sp,
          borderRadius: 2.sp,
        ),
        SpacerHorizontal(width: 22.sp),
        GradientContainerWidget(
          height: 14.sp,
          width: 100.sp,
          borderRadius: 2.sp,
        ),
        SpacerHorizontal(width: 22.sp),
        GradientContainerWidget(
          height: 14.sp,
          width: 100.sp,
          borderRadius: 2.sp,
        )
      ],
    );
  }
}
