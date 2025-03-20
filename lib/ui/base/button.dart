import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

//
class BaseButton extends StatelessWidget {
  const BaseButton({
    this.onPressed,
    this.text = "Submit",
    this.color,
    this.disableTextColor,
    this.textColor,
    this.iconColor,
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
    this.side = BorderSide.none,
    this.textStyle,
    this.icon,
  });

  final String text;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final Color? disableTextColor;

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
    return Container(
      margin: margin,
      // width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor:
              disabledBackgroundColor ?? ThemeColors.primary10,
          backgroundColor: color ?? ThemeColors.primary100,
          shadowColor: Colors.transparent,
          elevation: 0,
          minimumSize: const Size.fromHeight(45),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: side,
          ),
        ),
        child: OptionalParent(
          addParent: icon != null,
          parentBuilder: (child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon ?? '',
                  color: iconColor ?? ThemeColors.neutral60,
                  height: 17,
                  width: 17,
                ),
                SpacerHorizontal(width: 8),
                child,
              ],
            );
          },
          child: Text(
            textAlign: textAlign,
            textUppercase ? text.toUpperCase() : text,
            style: textStyle ??
                (fontBold
                    ? styleBaseBold(
                        fontSize: textSize,
                        color: onPressed == null
                            ? disableTextColor ?? ThemeColors.primary100
                            : textColor ?? ThemeColors.black,
                      )
                    : styleBaseSemiBold(
                        fontSize: textSize,
                        color: onPressed == null
                            ? disableTextColor ?? ThemeColors.primary100
                            : textColor ?? ThemeColors.black,
                      )),
          ),
        ),
      ),
    );
  }
}
