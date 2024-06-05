import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FaqScreenSimmer extends StatelessWidget {
  const FaqScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SpacerVertical(height: 10);
        }
        return GradientContainerWidget(
          height: 70.sp,
          borderRadius: Dimen.radius.r,
        );
      },
      separatorBuilder: (context, index) {
        return const SpacerVertical();
      },
    );
  }
}
