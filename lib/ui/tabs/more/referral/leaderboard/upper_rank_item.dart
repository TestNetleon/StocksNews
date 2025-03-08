import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/referral/leader_board.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

class UpperRankItem extends StatelessWidget {
  const UpperRankItem({
    super.key,
    required this.data,
    required this.constraints,
    required this.index,
  });

  final int index;
  final LeaderBoardData data;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    double width = (constraints.maxWidth - 36) / 3;

    return Container(
      margin: EdgeInsets.only(
        top: (index == 0)
            ? 0
            : (index == 1)
                ? 30
                : (index == 2)
                    ? 60
                    : 0,
      ),
      padding: EdgeInsets.all(12),
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
                  child: data.imageType == "svg"
                      ? SvgPicture.network(
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
                          data.image ?? "",
                          placeholderBuilder: (BuildContext context) =>
                              Container(
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
                  // child: Image.network(data.image ?? ""),
                  child: Text(
                    "${index + 1}",
                    style: styleBaseBold(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          SpacerVertical(height: 8),
          Text(
            data.displayName ?? "",
            style: styleBaseBold(fontSize: 14, color: ThemeColors.splashBG),
            textAlign: TextAlign.center,
          ),
          SpacerVertical(height: 8),
          Text(
            "${data.points}",
            style: styleBaseRegular(fontSize: 14, color: ThemeColors.neutral40),
            textAlign: TextAlign.center,
          ),
          SpacerVertical(height: 8),
        ],
      ),
    );
  }
}
