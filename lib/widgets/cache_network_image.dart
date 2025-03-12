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
    this.loadingColor,
    this.color,
  });

  final String? imagesUrl;
  final double? height, width;
  final BoxFit fit;
  final bool extraSpacing;
  final bool showLoading;
  final Color? loadingColor;
  final String? placeHolder;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: imagesUrl ?? "",
      color: color,
      placeholder: (context, url) => showLoading
          ? placeHolder != null
              ? Image.asset(
                  placeHolder ?? Images.placeholder,
                  width: width?.sp,
                  fit: fit,
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: loadingColor ?? ThemeColors.black,
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
