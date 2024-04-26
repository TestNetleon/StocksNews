import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';

class DrawerBackpress extends StatelessWidget {
  const DrawerBackpress({super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColors.lightGreen.withOpacity(0.3),
          width: 2.sp,
        ),
        color: ThemeColors.accent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.sp),
          bottomLeft: Radius.circular(20.sp),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.sp),
          bottomLeft: Radius.circular(20.sp),
        ),
        onTap: () {
          Scaffold.of(context).closeDrawer();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.sp, vertical: 10.sp),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 12.sp,
          ),
        ),
      ),
    );
  }
}
