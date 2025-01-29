import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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

            return TournamentLeaderboardItem(data: data, from: 1);
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
