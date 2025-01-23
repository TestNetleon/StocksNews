import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../../models/leaderboard.dart';

class TournamentLeaderboardItem extends StatelessWidget {
  final LeaderboardByDateRes data;
  final bool decorate;
  const TournamentLeaderboardItem(
      {super.key, required this.data, this.decorate = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: decorate
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
          : null,
      decoration: decorate
          ? BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(5),
            )
          : null,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Visibility(
                  visible: data.position != null,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.greyBorder,
                    ),
                    child: Text(
                      '${data.position}',
                      style: styleGeorgiaBold(fontSize: 11),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.greyBorder)),
                    child: data.imageType == "svg"
                        ? SvgPicture.network(
                            fit: BoxFit.cover,
                            data.userImage ?? "",
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(
                                color: ThemeColors.accent,
                              ),
                            ),
                          )
                        : CachedNetworkImagesWidget(
                            data.userImage,
                          ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.userName ?? 'N/A',
                                style: styleGeorgiaBold(),
                              ),
                              Text(
                                data.rank ?? 'N/A',
                                style: styleGeorgiaRegular(
                                    color: ThemeColors.greyText, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: data.totalChange != null,
            child: Text(
              '${data.totalChange?.toCurrency()}%',
              style: stylePTSansRegular(
                fontSize: 14,
                color: (data.totalChange ?? 0) > 0 ? Colors.green : Colors.red,
              ),
            ),
          ),
          decorate == false
              ? Visibility(
                  visible: data.performance != null,
                  child: Text(
                    '${data.performance}%',
                    style: styleGeorgiaBold(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                )
              : Visibility(
                  visible: data.totalPoints != null,
                  child: Text(
                    '${data.totalPoints}',
                    style: styleGeorgiaBold(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
