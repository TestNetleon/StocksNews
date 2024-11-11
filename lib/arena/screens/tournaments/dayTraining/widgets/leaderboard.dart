import 'package:flutter/material.dart';
import 'package:stocks_news_new/arena/widgets/card.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/featured/widgets/title.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class DayTrainingLeaderboard extends StatelessWidget {
  const DayTrainingLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          FeaturedWatchlistTitle(
            title: 'Leaderboard',
            onTap: () {},
          ),
          ArenaThemeCard(
            margin: EdgeInsets.only(top: 10),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            ThemeColors.greyBorder.withOpacity(0.4),
                      ),
                      SpacerHorizontal(width: 10),
                      Expanded(
                        child: Text(
                          'RobinSon T.',
                          style: styleGeorgiaRegular(),
                        ),
                      ),
                      Text(
                        '325.07%',
                        style: stylePTSansRegular(
                          fontSize: 13,
                          color: ThemeColors.accent,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                );
              },
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
