import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/dayTraining/open/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/play_box.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class DayTrainingTitle extends StatelessWidget {
  final int? tournamentId;

  const DayTrainingTitle({super.key, this.tournamentId});

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueDetailRes? detailRes = manager.detailRes;

    return Column(
      children: [
        CommonCard(
          margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
          padding:
              EdgeInsets.symmetric(horizontal: Pad.pad14, vertical: Pad.pad16),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: detailRes?.tournamentBattleId != null
                          ? 'Closes in '
                          : 'Starts in',
                      style: styleBaseBold(fontSize: 14),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Text(
                        ' ${manager.timeRemaining['hours']} ',
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
                        ' ${manager.timeRemaining['minutes']} ',
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
                        ' ${manager.timeRemaining['seconds']} ',
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
              const SpacerVertical(height: Pad.pad10),
              Visibility(
                visible: detailRes?.tournamentBattleId != null,
                child: LinearProgressIndicator(
                  value: manager.progress,
                  backgroundColor: ThemeColors.neutral5,
                  minHeight: 8.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(manager.progressColor),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Visibility(
                visible: detailRes?.tournamentBattleId == null,
                child: LinearProgressIndicator(
                  value: manager.progress,
                  backgroundColor: ThemeColors.neutral5,
                  minHeight: 8.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(manager.progressColor),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SpacerVertical(height: Pad.pad10),
              Row(
                children: [
                  Visibility(
                    visible: detailRes?.tournamentLastDate != null,
                    child: Expanded(
                      child: CommonCard(
                        padding: EdgeInsets.symmetric(
                            horizontal: Pad.pad10, vertical: Pad.pad10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Last League Ended On :",
                              style: styleBaseRegular(
                                  fontSize: 12,
                                  color: ThemeColors.neutral80
                                      .withValues(alpha: 0.8)),
                              textAlign: TextAlign.center,
                            ),
                            SpacerVertical(height: Pad.pad14),
                            Text(
                              detailRes?.tournamentLastDate ?? "",
                              style: styleBaseSemiBold(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: Pad.pad10),
                  Visibility(
                    visible: manager.detailRes?.tournamentNextDate != null,
                    child: Expanded(
                      child: CommonCard(
                        padding: EdgeInsets.symmetric(
                            horizontal: Pad.pad10, vertical: Pad.pad10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Upcoming League On:",
                              style: styleBaseRegular(
                                  fontSize: 12,
                                  color: ThemeColors.neutral80
                                      .withValues(alpha: 0.8)),
                              textAlign: TextAlign.center,
                            ),
                            SpacerVertical(height: Pad.pad14),
                            Text(
                              detailRes?.tournamentNextDate ?? "",
                              style: styleBaseSemiBold(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SpacerVertical(height: Pad.pad10),
              Row(
                children: [
                  Expanded(
                    child: CommonCard(
                      padding: EdgeInsets.symmetric(
                          horizontal: Pad.pad10, vertical: Pad.pad10),
                      child: RichText(
                        text: TextSpan(
                          text: 'Start Time: ',
                          style: styleBaseRegular(
                              color:
                                  ThemeColors.neutral80.withValues(alpha: 0.8),
                              fontSize: 14),
                          children: [
                            TextSpan(
                              style: styleBaseBold(fontSize: 14),
                              text: '${detailRes?.tournamentStartTime}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: Pad.pad10),
                  Expanded(
                    child: CommonCard(
                      padding: EdgeInsets.symmetric(
                          horizontal: Pad.pad10, vertical: Pad.pad10),
                      child: RichText(
                        text: TextSpan(
                          text: 'End Time: ',
                          style: styleBaseRegular(
                              color:
                                  ThemeColors.neutral80.withValues(alpha: 0.8),
                              fontSize: 14),
                          children: [
                            TextSpan(
                              style: styleBaseBold(fontSize: 14),
                              text: '${detailRes?.tournamentEndTime}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SpacerVertical(),
        PlayBoxLeague(
          title: detailRes?.name ?? '',
          imageUrl: detailRes?.image,
          description: detailRes?.description ?? '',
          pointText: 'Prize Pool',
          points: detailRes?.point ?? '',
          tournamentPoints: detailRes?.tournamentPoints ?? [],
          onButtonTap: () {
            if (detailRes?.joined == false) {
              manager.joinLeague(id: tournamentId);
            } else {
              // Navigator.pushNamed(context, LeagueTickersIndex.path);
              Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                      builder: (context) => LeagueTickersIndex()));
            }
          },
          buttonText: detailRes?.showButton ?? 'Open',
          buttonVisibility: detailRes?.tournamentBattleId != null,
        ),
      ],
    );
  }
}
