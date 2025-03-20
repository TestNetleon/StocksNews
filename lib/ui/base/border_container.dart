import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class BaseBorderContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? innerPadding;
  final Color? color;
  final Color? borderColor;

  final void Function()? onTap;
  const BaseBorderContainer({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.innerPadding,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(Pad.pad8),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Pad.pad8),
            border: Border.all(color: borderColor ?? ThemeColors.neutral5),
            color: color,
          ),
          padding: innerPadding ?? EdgeInsets.all(Pad.pad16),
          child: child,
        ),
      ),
    );
  }
}
