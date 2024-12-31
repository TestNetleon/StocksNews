import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
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
    ArenaProvider provider = context.watch<ArenaProvider>();
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
                    child: data?[index].imageType == "svg"
                        ? SvgPicture.network(
                            fit: BoxFit.cover,
                            data?[index].image ?? "",
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(
                                color: ThemeColors.accent,
                              ),
                            ),
                          )
                        : CachedNetworkImagesWidget(data?[index].image),
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
            "${data?[index].avgTotalChange}",
            style: stylePTSansBold(
              color: index == 2
                  ? ThemeColors.sos
                  : index == 1
                      ? Colors.orange
                      : ThemeColors.accent,
            ),
          ),
          Text(
            data?[index].name ?? 'N/A',
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
