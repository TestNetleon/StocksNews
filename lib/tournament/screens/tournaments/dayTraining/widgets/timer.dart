import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/play_box.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';
import '../../../../models/tournament_detail.dart';
import '../../../../widgets/card.dart';
import '../open/index.dart';

class DayTrainingTitle extends StatelessWidget {
  final int? tournamentId;

  const DayTrainingTitle({super.key, this.tournamentId});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    TournamentDetailRes? detailRes = provider.detailRes;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TournamentThemeCard(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 15,
            ),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: provider.detailRes?.tournamentBattleId != null
                            ? 'Closes in '
                            : 'Starts in',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          ' ${provider.timeRemaining['hours']} ',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ),
                      TextSpan(
                        text: ' hours : ',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          ' ${provider.timeRemaining['minutes']} ',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ),
                      TextSpan(
                        text: ' minutes : ',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          ' ${provider.timeRemaining['seconds']} ',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ),
                      TextSpan(
                        text: ' seconds ',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: ThemeColors.greyText,
                ),
                Text(
                  'Trading league Time',
                  style: styleGeorgiaBold(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: 'Start Time: ',
                            style: styleGeorgiaRegular(
                                color: ThemeColors.greyText, fontSize: 14),
                            children: [
                              TextSpan(
                                style: styleGeorgiaRegular(fontSize: 14),
                                text:
                                    '${provider.detailRes?.tournamentStartTime}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: 'End Time: ',
                            style: styleGeorgiaRegular(
                                color: ThemeColors.greyText, fontSize: 14),
                            children: [
                              TextSpan(
                                style: styleGeorgiaRegular(fontSize: 14),
                                text:
                                    '${provider.detailRes?.tournamentEndTime}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: PlayBoxTournament(
            title: detailRes?.name ?? '',
            imageUrl: provider.detailRes?.image,
            description: provider.detailRes?.description ?? '',
            pointText: 'Prize Pool',
            points: detailRes?.point ?? '',
            onButtonTap: () {
              if (provider.detailRes?.joined == false) {
                provider.joinTounament(id: tournamentId);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TournamentOpenIndex(),
                  ),
                );
              }
            },
            buttonText: detailRes?.showButton ?? 'Open',
            buttonVisibility: provider.detailRes?.tournamentBattleId != null,
          ),
        ),
      ],
    );
  }
}
