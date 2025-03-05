import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';

class BaseListDivider extends StatelessWidget {
  const BaseListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: ThemeColors.neutral5, height: 1, thickness: 1);
  }
}
