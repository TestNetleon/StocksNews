import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class BaseColorContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final Color? bgColor;
  const BaseColorContainer({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Pad.pad8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor??ThemeColors.secondary100,
          borderRadius: BorderRadius.circular(Pad.pad8),
        ),
        padding: padding??EdgeInsets.all(Pad.pad16),
        child: child,
      ),
    );
  }
}
