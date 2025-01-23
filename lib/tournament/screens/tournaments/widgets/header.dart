import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/tournament.dart';
import '../pointsPaid/index.dart';

class TournamentHeader extends StatelessWidget {
  const TournamentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(0.9),
          colors: [
            ThemeColors.bottomsheetGradient,
            ThemeColors.accent,
          ],
        ),
      ),
      child: Row(
        children: List.generate(
          provider.data?.tournamentHeader?.length ?? 0,
          (index) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    var selectedTournament = TournamentsHead.tradTotal;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TournamentPointsPaidIndex(selectedTournament:selectedTournament);
                      },
                    ));
                  }
                 else if (index == 1) {
                    var selectedTournament = TournamentsHead.pPaid;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TournamentPointsPaidIndex(selectedTournament:selectedTournament);
                      },
                    ));
                  }
                  else if (index == 2) {
                    var selectedTournament = TournamentsHead.playTraders;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TournamentPointsPaidIndex(selectedTournament:selectedTournament);
                      },
                    ));
                  }
                },
                child: Column(
                  children: [
                    Text(
                      provider.data?.tournamentHeader?[index].label ?? '',
                      style: styleGeorgiaRegular(fontSize: 13),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height:10),
                    Text(
                      provider.data?.tournamentHeader?[index].value ?? '',
                      style: styleGeorgiaBold(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
