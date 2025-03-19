import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class BaseColorContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final Color? bgColor;
  final double? radius;

  const BaseColorContainer({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.bgColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Pad.pad8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? ThemeColors.secondary120,
          borderRadius: BorderRadius.circular(radius ?? Pad.pad8),
        ),
        padding: padding ?? EdgeInsets.all(Pad.pad16),
        child: child,
      ),
    );
  }
}
