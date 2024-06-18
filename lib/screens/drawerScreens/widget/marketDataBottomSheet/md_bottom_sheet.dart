import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MdBottomSheet extends StatelessWidget {
  const MdBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: ThemeColors.greyBorder,
          height: 0.sp,
          thickness: 1.sp,
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Text(
                  "data",
                  style: stylePTSansBold(color: Colors.black),
                ),
              ),
              Text(
                "data",
                style: stylePTSansBold(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
