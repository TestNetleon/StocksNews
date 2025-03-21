import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';


class TournamentLeaderboardTopItem extends StatelessWidget {
  final int index;
  const TournamentLeaderboardTopItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    TournamentLeaderboardProvider provider =
        context.watch<TournamentLeaderboardProvider>();
    List<LeaderboardByDateRes?> data = provider.topPerformers;

    if (data.isEmpty == true) {
      return const SizedBox();
    }
    if (data.length == 1 && (index == 1 || index == 2)) {
      return const SizedBox();
    }
    if (data.length == 2 && index == 2) {
      return const SizedBox();
    }

    return SizedBox(
      width: ScreenUtil().screenWidth / 3,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              InkWell(
                onTap: () {
                  context.read<TournamentProvider>().profileRedirection(
                      userId: "${data[index]?.userId ?? ""}");
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 2
                        ? ThemeColors.bronze
                        : index == 1
                            ? ThemeColors.silver
                            : ThemeColors.gold,
                  ),
                  padding: const EdgeInsets.all(1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CircleAvatar(
                      radius: index == 1 || index == 2 ? 35 : 45,
                      child: data[index]?.imageType == "svg"
                          ? SvgPicture.network(
                              fit: BoxFit.cover,
                              data[index]?.userImage ?? "",
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator(
                                  color: ThemeColors.accent,
                                ),
                              ),
                            )
                          : CachedNetworkImagesWidget(data[index]?.userImage),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: index == 2
                    ? ThemeColors.bronze
                    : index == 1
                        ? ThemeColors.silver
                        : ThemeColors.gold,
                child: Text("${index + 1}",
                    style: styleBaseBold()),
              ),
            ],
          ),
          const SpacerVertical(height: 7),
          Text(
            data[index]?.userName?.capitalizeWords() ?? 'N/A',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styleBaseRegular(
                color: index == 2
                    ? ThemeColors.bronze
                    : index == 1
                        ? ThemeColors.silver
                        : ThemeColors.gold,
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: data[index]?.rank != null,
            child: Text(
              "${data[index]?.rank}",
              style: styleBaseRegular(
                  color: index == 2
                      ? ThemeColors.bronze
                      : index == 1
                          ? ThemeColors.silver
                          : ThemeColors.gold,
                  fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          const SpacerVertical(height: 50)
        ],
      ),
    );
  }
}
