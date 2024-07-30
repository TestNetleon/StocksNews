import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:svg_flutter/svg_flutter.dart';

class ProfileImage extends StatelessWidget {
  final double imageSize;
  final double cameraSize;
  final Function()? onTap;
  final String? url;
  final IconData? icon;
  final bool showCameraIcon;
  final bool roundImage;
  // final bool isSVG;

  const ProfileImage({
    super.key,
    this.imageSize = 60,
    this.cameraSize = 14,
    this.onTap,
    this.url,
    this.icon,
    // this.isSVG = false,
    this.showCameraIcon = true,
    this.roundImage = true,
  });
//
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: roundImage
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeColors.white, width: 3),
                      shape: BoxShape.circle),
                  child: ClipOval(
                    child: isSVG
                        ? SvgPicture.network(
                            height: imageSize,
                            width: imageSize,
                            url ?? "",
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : CachedNetworkImagesWidget(
                            url,
                            height: imageSize,
                            width: imageSize,
                            showLoading: true,
                            placeHolder: Images.userPlaceholder,
                          ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.white, width: 3),
                  ),
                  // padding: EdgeInsets.all(3),
                  child: isSVG
                      ? SvgPicture.network(
                          height: imageSize,
                          width: imageSize,
                          url ?? "",
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                            padding: const EdgeInsets.all(30.0),
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : CachedNetworkImagesWidget(
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
          child: Visibility(
            visible: showCameraIcon,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ThemeColors.accent),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipOval(
                    child: Icon(
                      icon ?? Icons.camera_alt,
                      size: cameraSize,
                    ),
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
