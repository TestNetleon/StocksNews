import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/linear_progress.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/play_box.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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
                          style: styleGeorgiaBold(fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: ' Hours : ',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          ' ${provider.timeRemaining['minutes']} ',
                          style: styleGeorgiaBold(fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: ' Minutes : ',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          ' ${provider.timeRemaining['seconds']} ',
                          style: styleGeorgiaBold(fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: ' Seconds ',
                        style: styleGeorgiaRegular(color: ThemeColors.greyText),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: ThemeColors.greyText,
                ),
                /*Visibility(
                  visible: provider.detailRes?.tournamentBattleId != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Closes in",
                        style: styleGeorgiaRegular(fontSize: 12,color: ThemeColors.white),
                      ),
                      SpacerVertical(height: 5),
                      LinearProgressIndicator(
                        value: provider.progress,
                        backgroundColor: ThemeColors.lightGreen.withAlpha(30),
                        minHeight: 7.0,
                        valueColor: AlwaysStoppedAnimation<Color>(provider.progressColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: provider.detailRes?.tournamentBattleId == null,
                  child: Column(
                    children: [
                      Text(
                        "Started At",
                        style: styleGeorgiaRegular(fontSize: 12,color: ThemeColors.primary),
                      ),
                      LinearProgressIndicator(
                        value: provider.progress,
                        backgroundColor: ThemeColors.lightGreen.withAlpha(30),
                        minHeight: 7.0,
                        valueColor: AlwaysStoppedAnimation<Color>(provider.progressColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                ),*/

                const SpacerVertical(height: 5),
                Text(
                  'Trading League Time',
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
                ),
                SpacerVertical(height: 3),
                Row(
                  children: [
                    Visibility(
                      visible: provider.detailRes?.tournamentLastDate != null,
                      child: Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            provider.detailRes?.tournamentLastDate??"",
                            style: styleGeorgiaRegular(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: provider.detailRes?.tournamentNextDate != null,
                      child: Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            provider.detailRes?.tournamentNextDate??"",
                            style: styleGeorgiaRegular(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
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
            tournamentPoints:detailRes?.tournamentPoints??[],
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
