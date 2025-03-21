import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/pointsPaid/index.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TournamentHeader extends StatelessWidget {
  const TournamentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient:  isDark ?
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(0.9),
          colors: [
            ThemeColors.bottomsheetGradient,
            ThemeColors.accent,
          ],
        ):null,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.boxShadow,
            blurRadius: 60,
            offset: Offset(0, 20),
          ),
        ],
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            provider.data?.tournamentHeader?[index].label ?? '',
                            style: styleBaseBold(fontSize: 13),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SpacerVertical(height:10),
                          Text(
                            provider.data?.tournamentHeader?[index].value ?? '',
                            style: styleBaseBold(fontSize:20),
                          ),
                        ],
                      ),
                    ),

                    Visibility(visible:index==2?false:true,child: SpacerHorizontal(width: 10)),
                    Visibility(
                      visible:index==2?false:true,
                      child: Container(
                        width:1.7,
                        height:40,
                        decoration: BoxDecoration(
                          color: ThemeColors.green11
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
      });
  }
}
