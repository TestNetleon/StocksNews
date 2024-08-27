import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NotificationScreenSimmer extends StatelessWidget {
  const NotificationScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: Dimen.padding),
      itemBuilder: (context, index) {
        return GradientContainerWidget(
          height: 300.sp,
          borderRadius: 5.sp,
        );
      },
      separatorBuilder: (context, index) {
        return const SpacerVertical(height: 14);
      },
      itemCount: 20,
    );
  }
}
