import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';

class ItemBack extends StatelessWidget {
  final Widget child;
  final Color? color;
  const ItemBack({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: ThemeColors.greyBorder),
        color: color ?? ThemeColors.primaryLight,
      ),
      child: child,
    );
  }
}
//