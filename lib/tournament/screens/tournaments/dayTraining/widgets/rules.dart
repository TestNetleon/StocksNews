import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../provider/tournament.dart';

class TournamentRules extends StatelessWidget {
  const TournamentRules({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: provider.detailRes?.tournamentPoints != null &&
                provider.detailRes?.tournamentPoints?.isNotEmpty == true,
            child: Row(
              children: List.generate(
                provider.detailRes?.tournamentPoints?.length ?? 0,
                (index) {
                  TournamentPointRes? data =
                      provider.detailRes?.tournamentPoints?[index];
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${data?.positionText}',
                          style: styleGeorgiaRegular(),
                        ),
                        SpacerVertical(height: 8),
                        CachedNetworkImagesWidget(
                          height: 70,
                          width: 70,
                          data?.image,
                          fit: BoxFit.contain,
                        ),
                        SpacerVertical(height: 8),
                        Text(
                          '${data?.points}',
                          style: styleGeorgiaBold(fontSize: 23),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Divider(
            color: ThemeColors.greyBorder,
            height: 20,
          ),
          Text(
            'Tournament Rules',
            style: styleGeorgiaBold(fontSize: 20),
          ),
          Visibility(
            visible: provider.detailRes?.tournamentRules != null &&
                provider.detailRes?.tournamentRules?.isNotEmpty == true,
            child: ListView.separated(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 14,
                      color: ThemeColors.greyBorder,
                    ),
                    SpacerHorizontal(width: 10),
                    Flexible(
                      child: Text(
                        '${provider.detailRes?.tournamentRules?[index]}',
                        style: styleGeorgiaRegular(height: 0.0),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                );
              },
              itemCount: provider.detailRes?.tournamentRules?.length ?? 0,
            ),
          )
        ],
      ),
    );
  }
}
