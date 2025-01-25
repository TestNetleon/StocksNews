import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../models/leaderboard.dart';
import '../leaderboard/item.dart';

class TopTraders extends StatelessWidget {
  final List<LeaderboardByDateRes>? list;
  const TopTraders({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          //padding: EdgeInsets.only(top: 5),
          itemBuilder: (context, index) {
            LeaderboardByDateRes? data = list?[index];
            if (data == null) {
              return SizedBox();
            }
           /* if (index == 0) {
              return Column(
                children: [
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * .5,
                        child: AutoSizeText(
                          maxLines: 1,
                          "POSITION",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      AutoSizeText(
                        maxLines: 1,
                        "POINTS",
                        textAlign: TextAlign.end,
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.greyText,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15,
                    thickness: 1,
                  ),
                  TournamentLeaderboardItem(data: data,from: 1),
                ],
              );
            }*/

            return TournamentLeaderboardItem(data: data,from: 1);
          },
          itemCount: list?.length ?? 0,
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 10);
          },
        );
      },
    );
  }
}
