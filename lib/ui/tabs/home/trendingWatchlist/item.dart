// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// import '../../../../models/ticker.dart';

// class HomeTrendingWatchlistItem extends StatelessWidget {
//   final BaseTickerRes data;
//   const HomeTrendingWatchlistItem({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0.4,
//       child: Container(
//         padding: EdgeInsets.all(Pad.pad16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(right: Pad.pad16),
//                   child: CachedNetworkImage(
//                     imageUrl: data.image ?? '',
//                     height: 30,
//                     width: 44,
//                   ),
//                 ),
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Text(
//                         data.symbol ?? '',
//                         style: styleBaseBold(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../models/ticker.dart';
import '../../../../widgets/spacer_vertical.dart';

class HomeTrendingWatchlistItem extends StatelessWidget {
  final BaseTickerRes data;
  const HomeTrendingWatchlistItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(28, 150, 171, 209),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Pad.pad16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: Pad.pad16),
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
            SpacerVertical(height: 12),
            Visibility(
              visible: data.price != null && data.price != '',
              child: Text(
                data.price ?? "",
                style: styleBaseBold(fontSize: 19),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  if (data.changesPercentage != null)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Image.asset(
                          (data.changesPercentage ?? 0) >= 0
                              ? Images.trendingUP
                              : Images.trendingDOWN,
                          height: 20,
                          width: 20,
                          color: (data.changesPercentage ?? 0) >= 0
                              ? ThemeColors.accent
                              : ThemeColors.sos,
                        ),
                      ),
                    ),
                  TextSpan(
                    text: data.change,
                    style: styleBaseRegular(
                      fontSize: 13,
                      color: (data.changesPercentage ?? 0) >= 0
                          ? ThemeColors.accent
                          : ThemeColors.sos,
                    ),
                  ),
                  if (data.changesPercentage != null)
                    TextSpan(
                      text: ' (${data.changesPercentage}%)',
                      style: styleBaseRegular(
                        fontSize: 13,
                        color: (data.changesPercentage ?? 0) >= 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
