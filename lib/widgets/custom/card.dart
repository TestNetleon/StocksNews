import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';

class CommonCard extends StatelessWidget {
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color>? colors;

  const CommonCard({
    super.key,
    this.gradient,
    this.padding,
    this.margin,
    this.child,
    this.colors,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(8),
        gradient: gradient ??
            LinearGradient(
              begin: begin,
              end: end,
              colors: colors ??
                  [
                    const Color.fromARGB(255, 23, 23, 23),
                    const Color.fromARGB(255, 39, 39, 39),
                  ],
            ),
      ),
      child: child,
    );
  }
}
