import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../../../models/my_home_premium.dart';
import '../../../../widgets/spacer_vertical.dart';

class HomePoliticianTradeItem extends StatelessWidget {
  final PoliticianTradeRes data;
  const HomePoliticianTradeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // bool showAuthor = data.authors != null && data.authors?.isNotEmpty == true;
    // bool showSite = data.site != null && data.site != '';
    // bool showDate = data.publishedDate != null && data.publishedDate != '';

    return Container(
      width: 224.sp,
      margin: EdgeInsets.only(bottom: Pad.pad24, right: Pad.pad24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImagesWidget(
              height: 224.sp,
              width: 224.sp,
              data.userImage,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Pad.pad10),
            child: Text(
              data.name ?? '',
              style: styleBaseBold(fontSize: 16),
            ),
          ),
          Visibility(
            visible: data.office != null && data.office != '',
            child: Text(
              data.office ?? '',
              style: styleBaseRegular(
                fontSize: 14,
                color: ThemeColors.neutral40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Pad.pad5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: Pad.pad8),
                        child: CachedNetworkImage(
                          imageUrl: data.image ?? '',
                          height: 30,
                          width: 44,
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.symbol ?? '',
                              style: styleBaseBold(),
                            ),
                            Text(
                              data.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleBaseRegular(
                                fontSize: 13,
                                color: ThemeColors.neutral40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SpacerVertical(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.type == 'Purchase'
                        ? ThemeColors.success10
                        : ThemeColors.error10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.type ?? '',
                    style: styleBaseBold(
                      fontSize: 14,
                      color: data.type == 'Purchase'
                          ? ThemeColors.success120
                          : ThemeColors.error120,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
