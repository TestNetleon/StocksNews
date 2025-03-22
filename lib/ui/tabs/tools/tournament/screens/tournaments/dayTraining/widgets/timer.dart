import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/open/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/play_box.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class DayTrainingTitle extends StatelessWidget {
  final int? tournamentId;

  const DayTrainingTitle({super.key, this.tournamentId});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    TournamentDetailRes? detailRes = provider.detailRes;

    return Column(
      children: [
        CommonCard(
          padding: EdgeInsets.symmetric(horizontal: Pad.pad10,vertical: Pad.pad10),
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
                      style: styleBaseBold(fontSize: 14),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Text(
                        ' ${provider.timeRemaining['hours']} ',
                        style: styleBaseBold(fontSize: 14),
                      ),
                    ),
                    TextSpan(
                      text: ' Hours : ',
                      style: styleBaseRegular(),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Text(
                        ' ${provider.timeRemaining['minutes']} ',
                        style: styleBaseBold(fontSize: 14),
                      ),
                    ),
                    TextSpan(
                      text: ' Minutes : ',
                      style: styleBaseRegular(fontSize: 14),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Text(
                        ' ${provider.timeRemaining['seconds']} ',
                        style: styleBaseBold(fontSize: 14),
                      ),
                    ),
                    TextSpan(
                      text: ' Seconds',
                      style: styleBaseRegular(),
                    ),
                  ],
                ),
              ),
              const SpacerVertical(height: 5),
              Visibility(
                visible: provider.detailRes?.tournamentBattleId != null,
                child: LinearProgressIndicator(
                  value: provider.progress,
                  backgroundColor: ThemeColors.neutral40.withAlpha(20),
                  minHeight: 4.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(provider.progressColor),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Visibility(
                visible: provider.detailRes?.tournamentBattleId == null,
                child: LinearProgressIndicator(
                  value: provider.progress,
                  backgroundColor: ThemeColors.neutral40.withAlpha(20),
                  minHeight: 4.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(provider.progressColor),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SpacerVertical(height: 8),

              Row(
                children: [
                  Visibility(
                    visible: provider.detailRes?.tournamentLastDate != null,
                    child: Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          provider.detailRes?.tournamentLastDate ?? "",
                          style: styleBaseRegular(fontSize: 11),
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
                          provider.detailRes?.tournamentNextDate ?? "",
                          style: styleBaseRegular(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SpacerVertical(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'Start Time: ',
                        style: styleBaseRegular(  color: ThemeColors.neutral80,fontSize: 14),
                        children: [
                          TextSpan(
                            style: styleBaseBold(fontSize: 14),
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
                        style: styleBaseRegular(
                            color: ThemeColors.neutral80, fontSize: 14),
                        children: [
                          TextSpan(
                            style: styleBaseBold(fontSize: 14),
                            text: '${provider.detailRes?.tournamentEndTime}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
            tournamentPoints: detailRes?.tournamentPoints ?? [],
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
