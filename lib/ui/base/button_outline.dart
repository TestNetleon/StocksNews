import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class BaseButtonOutline extends StatelessWidget {
  const BaseButtonOutline({
    this.onPressed,
    this.text = "Submit",
    this.borderColor = ThemeColors.accent,
    this.disableTextColor,
    this.textColor = Colors.white,
    this.textSize = 18,
    this.fullWidth = false,
    this.radius = 8,
    this.fontBold = true,
    this.elevation = 2,
    this.padding,
    this.margin,
    this.textAlign = TextAlign.center,
    this.textUppercase = false,
    this.borderWidth = 2,
    this.child,
    super.key,
  });

  final String text;
  final Color textColor;
  final Color? disableTextColor;
  final Color? borderColor;
  final Function()? onPressed;
  final double textSize;
  final double radius;
  final bool fullWidth, fontBold;
  final double elevation;
  final EdgeInsets? padding, margin;
  final TextAlign? textAlign;
  final bool textUppercase;
  final double borderWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          minimumSize: const Size.fromHeight(45),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth,
            ),
          ),
        ),
        child:
        child ??
        Text(
          textAlign: textAlign,
          textUppercase ? text.toUpperCase() : text,
          style: fontBold
              ? styleBaseBold(
                  fontSize: textSize,
                  color: onPressed == null
                      ? disableTextColor ?? ThemeColors.primary100
                      : textColor,
                )
              : styleBaseRegular(
                  fontSize: textSize,
                  color: onPressed == null
                      ? disableTextColor ?? ThemeColors.primary100
                      : textColor,
                ),
        ),
      ),
    );
  }
}
