import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';


class LeaderboardTopItem extends StatelessWidget {
  final int index;
  final BoxConstraints constraints;
  const LeaderboardTopItem({super.key, required this.index, required this.constraints});

  @override
  Widget build(BuildContext context) {
    LeaderboardManager manager = context.watch<LeaderboardManager>();
    List<TradingRes?> data = manager.topPerformers;
    if (data.isEmpty == true) {
      return const SizedBox();
    }
    if (data.length == 1 && (index == 1 || index == 2)) {
      return const SizedBox();
    }
    if (data.length == 2 && index == 2) {
      return const SizedBox();
    }
    double width = (constraints.maxWidth - 36) / 3;
    return InkWell(
      onTap: (){
        context.read<LeagueManager>().profileRedirection(
            userId: "${data[index]?.userId ?? ""}");
      },
      child: Container(
        margin: EdgeInsets.only(
          top: (index == 0)
              ? 0
              : (index == 1)
              ? 30
              : (index == 2)
              ? 60
              : 0,
        ),
        padding: EdgeInsets.symmetric(horizontal:Pad.pad5,vertical: Pad.pad10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Pad.pad8),
          border: Border.all(color: ThemeColors.neutral5),
        ),
        width: width,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.only(top: 6, left: 10, right: 10),
                  width: width / 2.5,
                  height: width / 2.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ThemeColors.secondary120),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(width / 5),
                    child: data[index]?.imageType == "svg"
                        ? SvgPicture.network(
                      fit: BoxFit.cover,
                      height: 24,
                      width: 24,
                      data[index]?.userImage ?? "",
                      placeholderBuilder: (BuildContext context) =>
                          Container(
                            padding: const EdgeInsets.all(30.0),
                            child: const CircularProgressIndicator(
                              color: ThemeColors.accent,
                            ),
                          ),
                    )
                        : CachedNetworkImage(
                      imageUrl: data[index]?.userImage ?? "",
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  child: Container(
                    padding: EdgeInsets.all(Pad.pad2),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0
                          ? ThemeColors.gold
                          : index == 1
                          ? ThemeColors.silver
                          : ThemeColors.bronze,
                    ),
                    alignment: Alignment.center,
                    child: Consumer<ThemeManager>(
                      builder: (context, value, child) {
                        return Text(
                          "${index + 1}",
                          style: styleBaseBold(
                            fontSize: 10,
                            color: value.isDarkMode
                                ? ThemeColors.white
                                : ThemeColors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SpacerVertical(height: 8),
            Text(
              data[index]?.userName?.capitalizeWords() ?? 'N/A',
              style: styleBaseBold(fontSize: 14, color: ThemeColors.splashBG),
              textAlign: TextAlign.center,
            ),
            SpacerVertical(height: 8),
            Visibility(
              visible: data[index]?.rank!=null,
              child: Text(
                "${data[index]?.rank}",
                style: styleBaseRegular(fontSize: 14, color: ThemeColors.neutral40),
                textAlign: TextAlign.center,
              ),
            ),
            SpacerVertical(height: 8),
          ],
        ),
      ),
    );
  }
}
