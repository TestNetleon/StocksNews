import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class ThemeButtonSmall extends StatelessWidget {
  const ThemeButtonSmall({
    required this.onPressed,
    this.text = "Submit",
    this.color = ThemeColors.accent,
    this.textColor = Colors.white,
    this.textSize = 14,
    this.radius = 4,
    this.fontBold = false,
    this.showArrow = true,
    this.elevation = 2,
    this.padding,
    this.icon,
    this.margin,
    this.textAlign = TextAlign.center,
    super.key,
    this.iconFront = false,
  });

  final String text;
  final Color? color;
  final Color textColor;
  final Function onPressed;
  final double textSize;
  final double radius;
  final IconData? icon;
  final bool fontBold;
  final bool showArrow;
  final bool iconFront;
  final double elevation;
  final EdgeInsets? padding, margin;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.sp),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: showArrow && iconFront,
            child: Container(
              margin: EdgeInsets.only(right: 8.sp),
              child: Icon(
                icon ?? Icons.arrow_forward,
                size: 20,
                color: textColor,
              ),
            ),
          ),
          Flexible(
            child: Text(
              textAlign: textAlign,
              text,
              style: fontBold
                  ? stylePTSansBold(
                      fontSize: textSize,
                      color: textColor,
                    )
                  : stylePTSansRegular(
                      fontSize: textSize,
                      color: textColor,
                    ),
            ),
          ),
          Visibility(
            visible: showArrow && !iconFront,
            child: Container(
              margin: EdgeInsets.only(left: 8.sp),
              child: Icon(
                icon ?? Icons.arrow_forward,
                size: 20,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
