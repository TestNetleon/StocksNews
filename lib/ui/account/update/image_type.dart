import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/theme.dart';

class UpdateImageType extends StatelessWidget {
  final Function()? onCamera, onGallery;

  const UpdateImageType({super.key, this.onCamera, this.onGallery});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onCamera,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.sp),
            child: Row(
              children: [
                Image.asset(
                  Images.photo,
                  height: 24,
                  width: 24,
                ),
                const SpacerHorizontal(width: 10),
                Text(
                  "Camera",
                  style: styleBaseRegular(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        BaseListDivider(),
        InkWell(
          onTap: onGallery,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.sp),
            child: Row(
              children: [
                Image.asset(
                  Images.photo,
                  height: 24,
                  width: 24,
                ),
                const SpacerHorizontal(width: 10),
                Text(
                  "Take Photo",
                  style: styleBaseRegular(fontSize: 16),
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
