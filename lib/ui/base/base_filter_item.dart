import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class BaseFilterItem extends StatelessWidget {
  final String value;
  final bool selected;
  final Widget? child;

  const BaseFilterItem({
    super.key,
    required this.value,
    required this.selected,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? ThemeColors.selectedBG : ThemeColors.white,
        border: Border.all(color: ThemeColors.neutral10, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      alignment: Alignment.center,
      child: child ??
          Text(
            value,
            style: selected
                ? styleBaseSemiBold(
                    fontSize: 14,
                    color: //selected ? ThemeColors.white :
                        ThemeColors.black,
                  )
                : styleBaseRegular(
                    fontSize: 14,
                    color: //selected ? ThemeColors.white :
                        ThemeColors.black,
                  ),
          ),
    );
  }
}
