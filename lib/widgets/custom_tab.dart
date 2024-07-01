import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    required this.index,
    required this.lable,
    required this.selectedIndex,
    super.key,
  });

  final int index;
  final String lable;
  final int selectedIndex;
//
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.greyBorder),
        color: selectedIndex == index
            ? ThemeColors.accent
            : ThemeColors.primaryLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        lable,
        style: stylePTSansBold(
          fontSize: 12, color: Colors.white,
          // index == selectedIndex ? ThemeColors.border : ThemeColors.primary,
        ),
      ),
    );
  }
}

class CustomTabNEW extends StatelessWidget {
  const CustomTabNEW({
    required this.index,
    required this.label,
    required this.selectedIndex,
    super.key,
  });

  final int index;
  final String label;
  final int selectedIndex;
//
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
        style: stylePTSansBold(
          fontSize: 13,
          color: Colors.white,
          // index == selectedIndex ? ThemeColors.border : ThemeColors.primary,
        ),
      ),
    );
  }
}
