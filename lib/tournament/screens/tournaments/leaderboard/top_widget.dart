import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../models/leaderboard.dart';

class TournamentLeaderboardTopItem extends StatelessWidget {
  final int index;
  const TournamentLeaderboardTopItem({super.key, required this.index});

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
                      ? ThemeColors.bronze
                      : index == 1
                          ? Colors.orange
                          : ThemeColors.accent,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: CircleAvatar(
                    radius: index == 1 || index == 2 ? 40 : 50,
                    child: data?[index].imageType == "svg"
                        ? SvgPicture.network(
                            fit: BoxFit.cover,
                            data?[index].userImage ?? "",
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(
                                color: ThemeColors.accent,
                              ),
                            ),
                          )
                        : CachedNetworkImagesWidget(data?[index].userImage),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: index == 2
                    ? ThemeColors.bronze
                    : index == 1
                        ? Colors.orange
                        : ThemeColors.accent,
                child: Text(
                  "${index + 1}",
                  style: index == 2
                      ? stylePTSansBold(color: ThemeColors.primary)
                      : stylePTSansBold(),
                ),
              ),
            ],
          ),
          const SpacerVertical(height: 5),
          Text(
            data?[index].userName ?? 'N/A',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: stylePTSansBold(
              color: index == 2
                  ? ThemeColors.bronze
                  : index == 1
                      ? Colors.orange
                      : ThemeColors.accent,
            ),
          ),
          Visibility(
            visible: data?[index].rank != null,
            child: Text(
              "${data?[index].rank}",
              style: stylePTSansBold(
                  color: index == 2
                      ? ThemeColors.bronze
                      : index == 1
                          ? Colors.orange
                          : ThemeColors.accent,
                  fontSize: 12),
            ),
          ),
          Visibility(
            visible: data?[index].totalPoints != null,
            child: Text(
              "${data?[index].totalPoints}",
              style: stylePTSansBold(
                  color: index == 2
                      ? ThemeColors.bronze
                      : index == 1
                          ? Colors.orange
                          : ThemeColors.accent,
                  fontSize: 12),
            ),
          ),
          Visibility(
            visible: data?[index].performance != null,
            child: Text(
              "${data?[index].performance}%",
              style: stylePTSansBold(
                  color: index == 2
                      ? ThemeColors.bronze
                      : index == 1
                          ? Colors.orange
                          : ThemeColors.accent,
                  fontSize: 12),
            ),
          ),

          /*Visibility(
            visible: data?[index].performance!=null,
            child: Text(
              "${data?[index].performance}%",
              style: stylePTSansBold(
                  color: index == 2
                      ? ThemeColors.sos
                      : index == 1
                      ? Colors.orange
                      : ThemeColors.accent,
                  fontSize: 12
              ),
            ),
          ),
          Visibility(
            visible: (data?[index].totalTrades!=null||data?[index].winRatio!=null),
            child: Text(
              "${data?[index].winRatio}% , ${data?[index].totalTrades}",
              style: stylePTSansBold(
                  color: index == 2
                      ? ThemeColors.sos
                      : index == 1
                      ? Colors.orange
                      : ThemeColors.accent,
                  fontSize: 12
              ),
            ),
          ),
*/
          const SpacerVertical(
            height: 50,
          )
        ],
      ),
    );
  }
}
