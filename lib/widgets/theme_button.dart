import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class ThemeButton extends StatelessWidget {
  const ThemeButton({
    this.onPressed,
    this.text = "Submit",
    this.color = ThemeColors.accent,
    this.textColor = Colors.white,
    this.textSize = 18,
    this.fullWidth = false,
    this.radius = 4, //Dimen.radius,
    this.fontBold = true,
    this.elevation = 2,
    this.padding,
    this.margin,
    this.child,
    this.textAlign = TextAlign.center,
    this.textUppercase = false,
    super.key,
  });

  final String text;
  final Color? color;
  final Color textColor;
  final Function()? onPressed;
  final double textSize;
  final double radius;
  final bool fullWidth, fontBold;
  final double elevation;
  final EdgeInsets? padding, margin;
  final TextAlign? textAlign;
  final Widget? child;
  final bool textUppercase;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: ThemeColors.border,

          backgroundColor: color,
          elevation: 0,
          minimumSize: const Size.fromHeight(45),
          padding: padding ??
              EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
          // (fullWidth
          //     ? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp)
          //     : EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.sp),
          ),
        ),
        child: child ??
            Text(
              textAlign: textAlign,
              textUppercase ? text.toUpperCase() : text,
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
    );
  }
}
