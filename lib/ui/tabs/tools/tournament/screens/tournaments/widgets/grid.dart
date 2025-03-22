import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/play_box.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class LeagueGrids extends StatelessWidget {
  const LeagueGrids({super.key});


  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        LeagueHeaderResDataRes? data = manager.data?.tournaments?[index];
        return PlayBoxLeague(
            title: data?.name ?? '',
            imageUrl: data?.image,
            description: data?.description ?? '',
            pointText: data?.pointText ?? '',
            points: data?.point ?? "0",
            tournamentPoints: manager.data?.tournamentPoints ?? [],
            onButtonTap: () {
              if (index == 0) {
                Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => TournamentDayTrainingIndex(
                      tournamentId: data?.tournamentId,
                    ),
                  ),
                );
              }
            },
            buttonText: "Play Game",
          buttonColor: ThemeColors.error120,
        );
      },
      separatorBuilder: (context, index) {
        return SpacerVertical(height: 10);
      },
      itemCount: manager.data?.tournaments?.length ?? 0,
    );
  }
}
