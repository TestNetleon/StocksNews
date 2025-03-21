import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class DayTrainingLeaderboard extends StatelessWidget {
  const DayTrainingLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          BaseHeading(
            title: provider.detailRes?.leaderboardTitle ?? "",
            viewMore: () {
              context.read<TournamentProvider>().leagueToLeaderboard();
            },
            subtitle: provider.detailRes?.leaderboardSubTitle ?? "",
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
