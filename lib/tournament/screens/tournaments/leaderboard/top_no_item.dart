import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../models/leaderboard.dart';

class TopNoItem extends StatelessWidget {
  final int index;
  const TopNoItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    TournamentLeaderboardProvider provider =
    context.watch<TournamentLeaderboardProvider>();
    List<LeaderboardByDateRes>? data =
        provider.leaderboardRes?.leaderboardByDate;

    if (data?.isEmpty == true) {
      return const SizedBox();
    }
    if (data?.length == 1 && (index == 1 || index == 2)) {
      return const SizedBox();
    }
    if (data?.length == 2 && index == 2) {
      return const SizedBox();
    }

    return SizedBox(
      width: ScreenUtil().screenWidth / 3,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 2
                        ? ThemeColors.bronze
                        : index == 1
                        ? ThemeColors.silver
                        : ThemeColors.gold,
                  ),
                  padding: const EdgeInsets.all(2),
                  child:SizedBox(
                    height:75,
                    width:75,
                    child:
                    Center(
                      child: Text(
                        "No Leaders",
                        style: styleGeorgiaRegular(
                            color: ThemeColors.primary,
                            fontSize: 12
                        ),
                      ),
                    ),
                  )
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: index == 2
                    ? ThemeColors.bronze
                    : index == 1
                    ? ThemeColors.silver
                    : ThemeColors.gold,
                child: Text(
                  "${index + 1}",
                  style:styleGeorgiaBold(color: ThemeColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
