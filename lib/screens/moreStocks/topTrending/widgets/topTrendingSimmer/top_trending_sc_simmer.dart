import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/simmer_effect_trending/trending_sc_simmer_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TopTrendingScreenSimmer extends StatelessWidget {
  const TopTrendingScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      padding: EdgeInsets.zero,
// Total number of items in the list
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Column(
            children: [
              SpacerVertical(),
              GradientContainerWidget(height: 150),
              SpacerVertical()
            ],
          );
        }

        return const TrendingScreenSimmerItem();
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index == 0) return const SizedBox();

        return const Divider(
          color: ThemeColors.greyBorder,
          height: 12,
        );
      },
    );
  }
}
