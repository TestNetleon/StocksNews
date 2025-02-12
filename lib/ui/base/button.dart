import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class BaseButton extends StatelessWidget {
  const BaseButton({
    this.onPressed,
    this.text = "Submit",
    this.color = ThemeColors.primary100,
    this.disableTextColor = ThemeColors.primary100,
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
    this.disabledBackgroundColor,
    super.key,
  });

  final String text;
  final Color? color;
  final Color textColor;
  final Color disableTextColor;

  final Function()? onPressed;
  final double textSize;
  final double radius;
  final bool fullWidth, fontBold;
  final double elevation;
  final EdgeInsets? padding, margin;
  final TextAlign? textAlign;
  final bool textUppercase;
  final Color? disabledBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor:
              disabledBackgroundColor ?? ThemeColors.primary10,
          backgroundColor: color,
          elevation: 0,
          minimumSize: const Size.fromHeight(45),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          textAlign: textAlign,
          textUppercase ? text.toUpperCase() : text,
          style: fontBold
              ? stylePTSansBold(
                  fontSize: textSize,
                  color: onPressed == null ? disableTextColor : textColor,
                )
              : stylePTSansRegular(
                  fontSize: textSize,
                  color: onPressed == null ? disableTextColor : textColor,
                ),
        ),
      ),
    );
  }
}
