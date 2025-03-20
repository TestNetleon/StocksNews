import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';

class CryptoContainer extends StatelessWidget {
  final Widget? child;
  final bool isDark;
  final EdgeInsetsGeometry? innerPadding;
  final void Function()? onTap;
  final bool? withWidth;
  const CryptoContainer({super.key,this.child, this.isDark=false, this.innerPadding,this.onTap,this.withWidth=false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: withWidth==true?200:null,
        padding: innerPadding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? null : ThemeColors.white,
          borderRadius: BorderRadius.circular(8),
          gradient: isDark ?
          withWidth==true?
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeColors.gradientGreen,
              ThemeColors.blackShade,
            ],
            stops: [0.0025, 0.5518],
          ):
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeColors.primary,
              ThemeColors.primary,
              ThemeColors.darkGreen.withValues(alpha: 0.2)
            ],
          ) : null,
          boxShadow: [
            BoxShadow(
              color: ThemeColors.boxShadow,
              blurRadius: 60,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
