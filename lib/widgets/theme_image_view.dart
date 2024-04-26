import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/constants.dart';

class ThemeImageView extends StatelessWidget {
  const ThemeImageView({
    required this.url,
    this.placeholder,
    this.fit = BoxFit.cover,
    super.key,
    this.height,
    this.width,
  });

  final String url;
  final String? placeholder;
  final BoxFit? fit;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      height: height?.sp,
      width: width?.sp,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          placeholder ?? Images.placeholder,
          fit: fit,
          height: height?.sp,
          width: width?.sp,
        );
      },
    );
  }
}
