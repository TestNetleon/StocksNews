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
  const TournamentLeaderboardItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
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
                            data.image ?? "",
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(
                                color: ThemeColors.accent,
                              ),
                            ),
                          )
                        : CachedNetworkImagesWidget(
                            data.image,
                          ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      data.name ?? 'N/A',
                      style: styleGeorgiaBold(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${data.avgTotalChange?.toCurrency()}%',
            style: stylePTSansRegular(
              fontSize: 14,
              color: (data.avgTotalChange ?? 0) > 0 ? Colors.green : Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
