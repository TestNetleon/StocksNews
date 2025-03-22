import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TournamentRules extends StatelessWidget {
  const TournamentRules({super.key});

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueDetailRes? leagueDetailRes= manager.detailRes;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: leagueDetailRes?.tournamentPoints != null &&
                leagueDetailRes?.tournamentPoints?.isNotEmpty == true,
            child: Row(
              children: List.generate(
                leagueDetailRes?.tournamentPoints?.length ?? 0,
                (index) {
                  LeaguePointRes? data =
                  leagueDetailRes?.tournamentPoints?[index];
                  return Expanded(
                    child: CommonCard(
                      padding: EdgeInsets.only(bottom: Pad.pad14),
                      margin: EdgeInsets.only(right: 4,left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImagesWidget(
                            height: 70,
                            width: 70,
                            data?.image,
                            fit: BoxFit.contain,
                          ),
                          SpacerVertical(height: Pad.pad10),
                          Text(
                            '${data?.points}',
                            style: styleBaseBold(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SpacerVertical(),
          Text(
            'Tournament Rules',
            style: styleBaseBold(fontSize: 24),
          ),
          SpacerVertical(),
          Visibility(
            visible: leagueDetailRes?.tournamentRules != null &&
                leagueDetailRes?.tournamentRules?.isNotEmpty == true,
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.secondary100)
                      ),
                      padding: EdgeInsets.all(Pad.pad2),
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: ThemeColors.secondary100,
                      ),
                    ),
                    SpacerHorizontal(width: Pad.pad16),
                    Expanded(
                      child: Text(
                        '${leagueDetailRes?.tournamentRules?[index]}',
                        style: styleBaseRegular(height: 1.4),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SpacerVertical(
                  height: 20,
                );
              },
              itemCount: leagueDetailRes?.tournamentRules?.length ?? 0,
            ),
          )
        ],
      ),
    );
  }
}
