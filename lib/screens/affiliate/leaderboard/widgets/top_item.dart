import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../../../providers/leaderboard.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';

class LeaderBoardTopItem extends StatelessWidget {
  final int index;
  const LeaderBoardTopItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();

    if (provider.leaderBoard?.isEmpty == true) {
      return const SizedBox();
    }
    if (provider.leaderBoard?.length == 1 && (index == 1 || index == 2)) {
      return const SizedBox();
    }

    if (provider.leaderBoard?.length == 2 && index == 2) {
      return const SizedBox();
    }

    return SizedBox(
      // color: ThemeColors.sos,
      width: ScreenUtil().screenWidth / 3,
      child: Column(
        children: [
          // if (index == 1 || index == 2)
          //   Container(color: ThemeColors.blue, height: 50),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 2
                      ? ThemeColors.sos
                      : index == 1
                          ? Colors.orange
                          : ThemeColors.accent,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: CircleAvatar(
                    radius: index == 1 || index == 2 ? 40 : 60,
                    child: CachedNetworkImagesWidget(
                        provider.leaderBoard?[index].image),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: index == 2
                    ? ThemeColors.sos
                    : index == 1
                        ? Colors.orange
                        : ThemeColors.accent,
                child: Text(
                  "${index + 1}",
                  style: stylePTSansBold(),
                ),
              ),
            ],
          ),
          const SpacerVertical(height: 5),
          Text(
            "${provider.leaderBoard?[index].points}",
            style: stylePTSansBold(
              color: index == 2
                  ? ThemeColors.sos
                  : index == 1
                      ? Colors.orange
                      : ThemeColors.accent,
            ),
          ),
          Text(
            "${provider.leaderBoard?[index].displayName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: stylePTSansBold(
              color: index == 2
                  ? ThemeColors.sos
                  : index == 1
                      ? Colors.orange
                      : ThemeColors.accent,
            ),
          ),
          const SpacerVertical(
            height: 50,
          )
        ],
      ),
    );
  }
}
