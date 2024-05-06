import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';

class IpoIndex extends StatelessWidget {
  const IpoIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container();
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 12.sp,
            color: ThemeColors.greyBorder,
          );
        },
        itemCount: 5);
  }
}
