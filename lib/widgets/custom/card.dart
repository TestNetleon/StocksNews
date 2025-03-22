import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class CommonCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final void Function()? onTap;

  const CommonCard({
    super.key,
    this.padding,
    this.margin,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(Pad.pad16),
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.neutral5),
          borderRadius: BorderRadius.circular(Pad.pad8),
        ),
        child: child,
      ),
    );
  }
}
