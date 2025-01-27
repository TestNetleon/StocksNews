import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/tournament.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/play_box.dart';
import 'package:stocks_news_new/utils/colors.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/tournament.dart';
import '../dayTraining/index.dart';

class TournamentGrids extends StatelessWidget {
  const TournamentGrids({super.key});

  _onTap(index, int? id) {
    if (index == 0) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => TournamentDayTrainingIndex(
            tournamentId: id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return ListView.separated(
      padding: EdgeInsets.only(top: 12),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        TournamentDataRes? data = provider.data?.tournaments?[index];

        return PlayBoxTournament(
            title: data?.name ?? '',
            imageUrl: data?.image,
            description: data?.description ?? '',
            pointText: data?.pointText ?? '',
            points: data?.point ?? "0",
            buttonColor: ThemeColors.themeGreen,
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
            buttonText: "Play Game");
      },
      separatorBuilder: (context, index) {
        return SpacerVertical(height: 10);
      },
      itemCount: provider.data?.tournaments?.length ?? 0,
    );
  }
}
