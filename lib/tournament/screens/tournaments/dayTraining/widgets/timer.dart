import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/theme_button.dart';
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
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              transform: GradientRotation(1),
              colors: [
                ThemeColors.bottomsheetGradient,
                ThemeColors.accent,
                ThemeColors.bottomsheetGradient,
              ],
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
            ),
            child: Row(
              children: [
                Container(
                  height: 110,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImagesWidget(
                      provider.detailRes?.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SpacerHorizontal(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible:
                            detailRes?.name != null && detailRes?.name != '',
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            detailRes?.name ?? '',
                            style: styleGeorgiaBold(fontSize: 20),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.detailRes?.description != null &&
                            provider.detailRes?.description != '',
                        child: Text(
                          '${provider.detailRes?.description}',
                          style:
                              styleGeorgiaRegular(color: ThemeColors.greyText),
                        ),
                      ),
                      Divider(color: ThemeColors.greyBorder, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prize Pool',
                            style:
                                styleGeorgiaBold(color: ThemeColors.greyText),
                          ),
                          Text(
                            detailRes?.point ?? '',
                            style: styleGeorgiaBold(fontSize: 20),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: provider.detailRes?.tournamentBattleId != null,
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
                              // provider.openTournament();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TournamentOpenIndex(),
                                ),
                              );
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
            ),
          ),
        ),
      ],
    );
  }
}
