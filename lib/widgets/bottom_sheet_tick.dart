import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';

class BottomSheetTick extends StatelessWidget {
  const BottomSheetTick({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.sp,
      height: 5,
      decoration: BoxDecoration(
        color: ThemeColors.divider,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
//