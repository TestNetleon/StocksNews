import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';

class CompareBarItemScreenSimmer extends StatelessWidget {
  const CompareBarItemScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientContainerWidget(
          height: 14,
          width: 50.sp,
          borderRadius: 2.sp,
        ),
        GradientContainerWidget(
          height: 14,
          width: 100.sp,
          borderRadius: 2.sp,
        ),
        GradientContainerWidget(
          height: 14,
          width: 100.sp,
          borderRadius: 2.sp,
        ),
        GradientContainerWidget(
          height: 14,
          width: 100.sp,
          borderRadius: 2.sp,
        )
      ],
    );
  }
}
