import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/referral/leader_board.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({
    super.key,
    required this.data,
    required this.index,
  });
  final LeaderBoardData data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            // margin: EdgeInsets.only(top: 6, left: 10, right: 10),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ThemeColors.secondary120),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: data.imageType == "svg"
                  ? SvgPicture.network(
                      fit: BoxFit.cover,
                      height: 24,
                      width: 24,
                      data.image ?? "",
                      placeholderBuilder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(30.0),
                        child: const CircularProgressIndicator(
                          color: ThemeColors.accent,
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: data.image ?? "",
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SpacerHorizontal(width: Pad.pad16),
          Container(
            padding: EdgeInsets.all(Pad.pad2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColors.silver,
            ),
            alignment: Alignment.center,
            // child: Image.network(data.image ?? ""),
            child: Consumer<ThemeManager>(builder: (context, value, child) {
              return Text(
                "${index + 1}",
                style: styleBaseBold(
                  fontSize: 11,
                  color:
                      value.isDarkMode ? ThemeColors.white : ThemeColors.black,
                ),
              );
            }),
          ),
          SpacerHorizontal(width: Pad.pad16),
          Expanded(
            child: Text(
              data.displayName ?? "",
              style: styleBaseBold(fontSize: 16),
            ),
          ),
          SpacerHorizontal(width: Pad.pad16),
          Column(
            children: [
              Text(
                "${data.points}",
                style: styleBaseBold(fontSize: 16),
              ),
              SpacerVertical(height: Pad.pad5),
              Text(
                "Points",
                style: styleBaseRegular(
                  fontSize: 14,
                  color: ThemeColors.neutral40,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
