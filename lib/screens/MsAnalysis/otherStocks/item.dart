import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/watchlist_res.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../utils/colors.dart';
import '../../../widgets/cache_network_image.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/spacer_vertical.dart';

class MsOtherStockItem extends StatelessWidget {
  final WatchlistData? data;
  const MsOtherStockItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Positioned(
            left: 15,
            right: 15,
            top: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 17, 253, 49),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ThemeColors.greyBorder),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.5],
                colors: [
                  ThemeColors.greyBorder.withOpacity(0.5),
                  Colors.black,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImagesWidget(
                      height: 30,
                      width: 30,
                      data?.image,
                    ),
                    SpacerHorizontal(width: 5),
                    Flexible(
                      child: Text(
                        data?.symbol ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleSansBold(color: ThemeColors.white),
                      ),
                    ),
                  ],
                ),
                SpacerVertical(height: 6),
                Text(
                  data?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: stylePTSansRegular(color: ThemeColors.greyText),
                ),
                SpacerVertical(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 17,
                      color: ThemeColors.accent,
                    ),
                    Flexible(
                      child: Text(
                        "${data?.changes ?? ""} (${data?.changesPercentage ?? ""}%)",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: stylePTSansRegular(color: ThemeColors.accent),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
