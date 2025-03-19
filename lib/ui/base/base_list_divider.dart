import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';

class BaseListDivider extends StatelessWidget {
  final double height;
  final Color? color;
  const BaseListDivider({super.key, this.height = 1, this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, value, child) {
        return Divider(
          color: color ?? ThemeColors.neutral5,
          height: height,
          thickness: value.isDarkMode ? 1 : 1,
        );
      },
    );
  }
}
