import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class DaysScreenSimmer extends StatelessWidget {
  const DaysScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.sp,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
              child: GradientContainerWidget(
                height: 20,
                borderRadius: 2.sp,
                width: 60.sp,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerHorizontal(width: 0);
        },
        itemCount: 4,
      ),
    );
  }
}
