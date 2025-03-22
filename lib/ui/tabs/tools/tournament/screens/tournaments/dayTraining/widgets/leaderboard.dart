import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';


class DayTrainingLeaderboard extends StatelessWidget {
  const DayTrainingLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueDetailRes? leagueDetailRes= manager.detailRes;
    return Column(
      children: [
        BaseHeading(
          title: leagueDetailRes?.leaderboardTitle ?? "",
          viewMore: () {
            manager.leagueToLeaderboard();
          },
          subtitle: leagueDetailRes?.leaderboardSubTitle ?? "",
          titleStyle: styleBaseBold(fontSize: 24),
          subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),
          margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad10),

        ),

        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TradingRes? data = leagueDetailRes?.todayLeaderboard?[index];
            if (data == null) {
              return SizedBox();
            }

            return TournamentLeaderboardItem(
              data: data,
              from: 3,
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider(height: 10);
          },
          itemCount: leagueDetailRes?.todayLeaderboard?.length ?? 0,
        )
      ],
    );
  }
}
