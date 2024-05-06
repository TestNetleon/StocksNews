import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class CachedNetworkImagesWidget extends StatelessWidget {
  const CachedNetworkImagesWidget(
    this.imagesUrl, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.extraSpacing = false,
    this.showLoading = false,
    this.placeHolder,
  });
  final String? imagesUrl;
  final double? height, width;
  final BoxFit fit;
  final bool extraSpacing;
  final bool showLoading;
  final String? placeHolder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width?.sp,
      height: height?.sp,
      fit: fit,
      imageUrl: imagesUrl ?? "",
      placeholder: (context, url) => showLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ThemeColors.blackShade.shade600,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Image.asset(
                Images.logoP,
                width: width?.sp,
                fit: BoxFit.contain,
              ),
            ),
      errorWidget: (context, url, error) => placeHolder != null
          ? Image.asset(
              placeHolder ?? Images.placeholder,
              width: width?.sp,
              fit: fit,
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Image.asset(
                Images.logoP,
                width: width?.sp,
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
