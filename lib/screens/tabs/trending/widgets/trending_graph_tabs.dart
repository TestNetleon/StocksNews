import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/custom_tab_item_label.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TrendingGraphTabs extends StatefulWidget {
  const TrendingGraphTabs({super.key});

  @override
  State<TrendingGraphTabs> createState() => _TrendingGraphTabsState();
}

class _TrendingGraphTabsState extends State<TrendingGraphTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 36,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ThemeColors.accent, width: 1.sp),
            ),
          ),
          child: Row(
            children: [
              CustomTabLabel(
                "S&P 500",
                coloredLetters: const ['S'],
                selected: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              VerticalDivider(
                color: ThemeColors.accent,
                width: 1.sp,
                thickness: 1.sp,
              ),
              CustomTabLabel(
                "NASDAQ",
                coloredLetters: const ['N'],
                selected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
        const SpacerVerticel(height: Dimen.padding),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedIndex == 0
              ? Container(
                  height: 200,
                  width: double.infinity,
                  color: ThemeColors.primaryLight,
                )
              : Container(
                  height: 200,
                  width: double.infinity,
                  color: ThemeColors.background,
                ),
        ),
      ],
    );
  }
}
