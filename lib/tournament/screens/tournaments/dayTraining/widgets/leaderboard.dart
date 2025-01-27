import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/widgets/card.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/featured/widgets/title.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

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
            title:  provider.detailRes?.leaderboardTitle??"",
            onTap: () {
              context.read<TournamentProvider>().leagueToLeaderboard();
            },
          ),
          Visibility(
            visible: provider.detailRes?.leaderboardSubTitle!=null,
            child: ScreenTitle(
              subTitle: provider.detailRes?.leaderboardSubTitle??"",
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              LeaderboardByDateRes? data =
              provider.detailRes?.todayLeaderboard?[index];
              if (data == null) {
                return SizedBox();
              }

              return TournamentLeaderboardItem(
                data: data,
                //decorate: false,
                from: 3,
              );
            },
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
            itemCount: provider.detailRes?.todayLeaderboard?.length ?? 0,
          )
        ],
      ),
    );
  }
}
