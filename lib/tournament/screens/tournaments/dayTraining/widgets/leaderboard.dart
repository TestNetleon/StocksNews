import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/widgets/card.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/featured/widgets/title.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../../models/leaderboard.dart';
import '../../leaderboard/item.dart';

class DayTrainingLeaderboard extends StatelessWidget {
  const DayTrainingLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          FeaturedWatchlistTitle(
            title: 'Leaderboard',
            onTap: () {},
          ),
          TournamentThemeCard(
            margin: EdgeInsets.only(top: 10),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                LeaderboardByDateRes? data =
                    provider.detailRes?.todayLeaderboard?[index];
                if (data == null) {
                  return SizedBox();
                }
                // return Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: Row(
                //     children: [
                //       CircleAvatar(
                //         radius: 20,
                //         backgroundColor:
                //             ThemeColors.greyBorder.withOpacity(0.4),
                //             child: ,
                //       ),
                //       SpacerHorizontal(width: 10),
                //       Expanded(
                //         child: Text(
                //           'RobinSon T.',
                //           style: styleGeorgiaRegular(),
                //         ),
                //       ),
                //       Text(
                //         '325.07%',
                //         style: stylePTSansRegular(
                //           fontSize: 13,
                //           color: ThemeColors.accent,
                //         ),
                //       ),
                //     ],
                //   ),
                // );

                return TournamentLeaderboardItem(
                  data: data,
                  decorate: false,
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                );
              },
              itemCount: provider.detailRes?.todayLeaderboard?.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
