import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/spacer_vertical.dart';
import '../../../../../widgets/theme_button.dart';
import '../../../../models/tournament_detail.dart';
import '../../../../widgets/card.dart';

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
                        text: provider.detailRes?.isMarketOpen == true
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
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Tournament',
                          style:
                              styleGeorgiaRegular(color: ThemeColors.greyText),
                        ),
                        SpacerVertical(height: 8),
                        Text(
                          detailRes?.name ?? '',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Prize Pool',
                          style:
                              styleGeorgiaRegular(color: ThemeColors.greyText),
                        ),
                        SpacerVertical(height: 8),
                        Text(
                          detailRes?.point ?? '',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                width: 100,
              ),
              Visibility(
                visible: provider.detailRes?.isMarketOpen == true,
                child: ThemeButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TournamentOpenIndex(),
                    //   ),
                    // );
                    if (provider.detailRes?.joined == false) {
                      provider.joinTounament(id: tournamentId);
                    } else {
                      provider.openTournament();
                    }
                  },
                  text: detailRes?.showButton ?? 'Open',
                  radius: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
