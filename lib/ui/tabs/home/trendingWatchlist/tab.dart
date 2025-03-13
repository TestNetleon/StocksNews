import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class HomeTopTabs extends StatelessWidget {
  final void Function(int)? onTap;
  final int selectedIndex;
  const HomeTopTabs({super.key, this.onTap, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: onTap,
      isScrollable: true,
      padding: EdgeInsets.only(bottom: Pad.pad20),
      tabs: [
        Tab(
          child: Text(
            'Trending',
            // style: styleBaseSemiBold(
            //   fontSize: 18,
            //   color: selectedIndex == 0
            //       ? ThemeColors.black
            //       : ThemeColors.neutral20,
            // ),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: selectedIndex == 1 ? ThemeColors.neutral20 : null,
                ),
          ),
        ),
        Tab(
          child: Text(
            'Watchlist',
            // style: styleBaseSemiBold(
            //   fontSize: 18,
            //   color: selectedIndex == 1
            //       ? ThemeColors.black
            //       : ThemeColors.neutral20,
            // ),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: selectedIndex == 0 ? ThemeColors.neutral20 : null,
                ),
          ),
        ),
      ],
      labelColor: Colors.black,
      unselectedLabelColor: ThemeColors.neutral20,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: ThemeColors.secondary100, width: 4),
        insets: EdgeInsets.symmetric(horizontal: Pad.pad32),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
