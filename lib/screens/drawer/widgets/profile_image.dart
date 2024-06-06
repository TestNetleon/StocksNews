import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

class ProfileImage extends StatelessWidget {
  final double imageSize;
  final double cameraSize;
  final Function()? onTap;
  final String? url;
  const ProfileImage({
    super.key,
    this.imageSize = 60,
    this.cameraSize = 14,
    this.onTap,
    this.url,
  });
//
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: ClipOval(
            // child: ThemeImageView(
            //   url: url ?? "",
            //   height: imageSize,
            //   width: imageSize,
            //   placeholder: Images.userPlaceholder,
            // ),

            child: CachedNetworkImagesWidget(
              url,
              height: imageSize,
              width: imageSize,
              showLoading: true,
              placeHolder: Images.userPlaceholder,
            ),
          ),
        ),
        Positioned(
          bottom: 3.sp,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: ThemeColors.accent),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipOval(
                  child: Icon(
                    Icons.camera_alt,
                    size: cameraSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
