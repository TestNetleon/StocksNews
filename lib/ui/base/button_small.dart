import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class BaseButtonSmall extends StatelessWidget {
  const BaseButtonSmall({
    this.onPressed,
    this.text = "Submit",
    this.color = ThemeColors.primary100,
    this.disableTextColor = ThemeColors.primary100,
    this.textColor,
    this.textSize = 14,
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
    this.side = BorderSide.none,
    this.textStyle,
    this.icon,
  });

  final String text;
  final Color? color;
  final Color? textColor;
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
  final BorderSide side;
  final TextStyle? textStyle;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor:
              disabledBackgroundColor ?? ThemeColors.primary10,
          backgroundColor: color,
          shadowColor: Colors.transparent,
          elevation: 0,
          minimumSize: const Size.fromHeight(32),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: side,
          ),
        ),
        child: Text(
          textAlign: textAlign,
          textUppercase ? text.toUpperCase() : text,
          style: textStyle ??
              styleBaseSemiBold(
                fontSize: textSize,
                color: onPressed == null
                    ? disableTextColor
                    : textColor ?? ThemeColors.black,
              ),
        ),
      ),
    );
  }
}
