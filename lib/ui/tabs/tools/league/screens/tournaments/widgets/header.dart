import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/pointsPaid/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class LeagueHeader extends StatelessWidget {
  const LeagueHeader({super.key});

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    return Row(
      children: List.generate(
        manager.data?.tournamentHeader?.length ?? 0,
        (index) {
          return Expanded(
            child: InkWell(
              onTap: () {
                EventsService.instance.tradingHeaderLeagueToolPage(index: index);
                if (index == 0) {
                  var selectedTournament = TournamentsHead.tradTotal;
                  // Navigator.pushNamed(context, LeagueTitansIndex.path,
                  //     arguments: {
                  //       "selectedTournament": selectedTournament,
                  //     });

                  Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) => LeagueTitansIndex(
                                selectedTournament: selectedTournament,
                              )));
                } else if (index == 1) {
                  var selectedTournament = TournamentsHead.pPaid;
                  // Navigator.pushNamed(context, LeagueTitansIndex.path,
                  //     arguments: {
                  //       "selectedTournament": selectedTournament,
                  //     });
                  Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) => LeagueTitansIndex(
                                selectedTournament: selectedTournament,
                              )));
                } else if (index == 2) {
                  var selectedTournament = TournamentsHead.playTraders;
                  // Navigator.pushNamed(context, LeagueTitansIndex.path,
                  //     arguments: {
                  //       "selectedTournament": selectedTournament,
                  //     });
                  Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) => LeagueTitansIndex(
                                selectedTournament: selectedTournament,
                              )));
                }
              },
              child: CommonCard(
                padding: EdgeInsets.symmetric(
                    horizontal: Pad.pad2, vertical: Pad.pad14),
                margin: EdgeInsets.only(right: 4, left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      manager.data?.tournamentHeader?[index].label ?? '',
                      style: styleBaseRegular(
                          fontSize: 12, color: ThemeColors.neutral80),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: Pad.pad14),
                    Text(
                      manager.data?.tournamentHeader?[index].value ?? '',
                      style: styleBaseBold(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
