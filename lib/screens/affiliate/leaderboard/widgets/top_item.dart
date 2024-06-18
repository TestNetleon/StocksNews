import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../../providers/leaderboard.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';

class LeaderBoardTopItem extends StatelessWidget {
  final int index;
  const LeaderBoardTopItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();

    return Container(
      color: ThemeColors.sos,
      child: Column(
        children: [
          // if (index == 1 || index == 2)
          //   Container(color: ThemeColors.blue, height: 50),
          CircleAvatar(
            radius: index == 1 || index == 2 ? 50 : 70,
            backgroundColor: ThemeColors.accent,
          ),
          const SpacerVertical(height: 5),
          Text(
            "${provider.leaderBoard?[index].points}",
            style: stylePTSansBold(),
          ),
          Text(
            "${provider.leaderBoard?[index].displayName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: stylePTSansBold(),
          ),
        ],
      ),
    );
  }
}
