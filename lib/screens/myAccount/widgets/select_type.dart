import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/theme.dart';

class MyAccountImageType extends StatelessWidget {
  final Function()? onCamera, onGallery;

  const MyAccountImageType({super.key, this.onCamera, this.onGallery});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onCamera,
          child: Container(
            width: double.infinity,
            // color: ThemeColors.primaryLight,
            padding: EdgeInsets.all(10.sp),
            child: Row(
              children: [
                Icon(Icons.camera_alt, color: ThemeColors.white, size: 20.sp),
                const SpacerHorizontal(width: 5),
                Text(
                  "Camera",
                  style: stylePTSansBold(
                      // color: ThemeColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: ThemeColors.greyBorder.withOpacity(0.4),
          thickness: 0.5,
        ),
        GestureDetector(
          onTap: onGallery,
          child: Container(
            width: double.infinity,
            // color: ThemeColors.primaryLight,
            padding: EdgeInsets.all(10.sp),
            child: Row(
              children: [
                Icon(Icons.photo, color: ThemeColors.white, size: 20.sp),
                const SpacerHorizontal(width: 5),
                Text(
                  "Gallery",
                  style: stylePTSansBold(
                      // color: ThemeColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
        SpacerVertical(height: ScreenUtil().bottomBarHeight),
      ],
    );
  }
}
