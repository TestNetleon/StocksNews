import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ImagePickerSheetContent extends StatelessWidget {
  final Function() onCameraClick;
  final Function() onGalleryClick;

  const ImagePickerSheetContent({
    required this.onCameraClick,
    required this.onGalleryClick,
    super.key,
  });
//
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpacerVertical(height: 16),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Choose Option",
              style: styleBaseBold(fontSize: 18),
            ),
          ),
          const SpacerVertical(height: 10),
          GestureDetector(
            onTap: onCameraClick,
            child: Container(
              width:
                  double.infinity, // Set the width to fill the available space
              padding: EdgeInsets.all(12.sp),
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 28.sp,
                    color: Colors.black87,
                  ),
                  const SpacerHorizontal(width: 10),
                  Expanded(
                    child: Text(
                      "Camera",
                      style: styleBaseRegular(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BaseListDivider(),
          GestureDetector(
            onTap: onGalleryClick,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.sp),
              child: Row(
                children: [
                  Icon(
                    Icons.photo,
                    size: 28.sp,
                    color: Colors.black87,
                  ),
                  const SpacerHorizontal(width: 10),
                  Expanded(
                    child: Text(
                      "Gallery",
                      style: styleBaseRegular(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpacerVertical(height: ScreenUtil().bottomBarHeight),
        ],
      ),
    );
  }
}
