import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/theme_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeIconButton extends StatelessWidget {
  const ThemeIconButton({
    required this.onPressed,
    required this.child,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final Function onPressed;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPressed();
      },
      child: SizedBox(
        height: 44.sp,
        width: 44.sp,
        child: ThemeCard(
          color: ThemeColors.primary,
          radius: 8,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
