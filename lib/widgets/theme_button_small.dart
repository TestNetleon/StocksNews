import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class ThemeButtonSmall extends StatelessWidget {
  const ThemeButtonSmall({
    this.onPressed,
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
    this.disabledColor,
    this.iconWidget,
    this.textAlign = TextAlign.center,
    super.key,
    this.iconFront = false,
    this.mainAxisSize = MainAxisSize.min,
  });

  final String text;
  final Color? color;
  final Color? disabledColor;

  final Color textColor;
  final Widget? iconWidget;
  final Function? onPressed;
  final double textSize;
  final double radius;
  final IconData? icon;
  final bool fontBold;
  final bool showArrow;
  final bool iconFront;
  final double elevation;
  final EdgeInsets? padding, margin;
  final TextAlign? textAlign;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed != null
            ? () {
                if (onPressed != null) {
                  onPressed!();
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: disabledColor,
          elevation: 0,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget ??
                Visibility(
                  visible: showArrow && iconFront,
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
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
                    ? styleBaseBold(
                        fontSize: textSize,
                        color: textColor,
                      )
                    : styleBaseRegular(
                        fontSize: textSize,
                        color: textColor,
                      ),
              ),
            ),
            Visibility(
              visible: showArrow && !iconFront,
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: Icon(
                  icon ?? Icons.arrow_forward,
                  size: 20,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
