import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/drawer_screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'item.dart';

class CompareNewPopularComparison extends StatelessWidget {
  const CompareNewPopularComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          DrawerScreenTitle(
            title: "Popular Stock Comparisons",
            style: stylePTSansBold(),
          ),
          const SpacerVertical(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 5),
            itemBuilder: (context, index) {
              return const CompareNewPopularItem();
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 10);
            },
            itemCount: 8,
          ),
        ],
      ),
    );
  }
}
