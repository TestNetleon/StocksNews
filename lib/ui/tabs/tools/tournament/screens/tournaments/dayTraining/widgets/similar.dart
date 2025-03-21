import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/widgets/card.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class DayTrainingSimilar extends StatelessWidget {
  const DayTrainingSimilar({super.key});

  @override
  Widget build(BuildContext context) {
    int length = 10;
    return TournamentThemeCard(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You can trade',
            style: styleBaseBold(),
          ),
          SpacerVertical(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                length,
                (index) {
                  return Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(
                      right: index == length - 1 ? 0 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.greyBorder,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  );
                },
              ),
            ),
          ),
          SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
