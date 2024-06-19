import 'package:flutter/material.dart';

import '../../../../widgets/spacer_vertical.dart';
import 'overview/desclaimer.dart';
import 'overview/top_widget.dart';

class SdCommonHeading extends StatelessWidget {
  const SdCommonHeading({this.showRating = false, super.key});
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    // StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    // CompanyInfo? companyInfo = provider.tabRes?.companyInfo;
    // KeyStats? keyStats = provider.tabRes?.keyStats;

    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Visibility(
          //       visible: companyInfo?.image != null,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(0),
          //         child: Container(
          //           padding: const EdgeInsets.all(5),
          //           width: 43,
          //           height: 43,
          //           child: CachedNetworkImagesWidget(
          //             companyInfo?.image ?? "",
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SpacerHorizontal(width: 12),
          //     Visibility(
          //       visible: keyStats?.symbol != null || keyStats?.name != null,
          //       child: Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               keyStats?.symbol ?? "",
          //               style: styleGeorgiaBold(fontSize: 18),
          //             ),
          //             const SpacerVertical(height: 5),
          //             Text(
          //               keyStats?.name ?? "",
          //               style: styleGeorgiaRegular(
          //                 color: ThemeColors.greyText,
          //                 fontSize: 14,
          //               ),
          //             ),
          //             if (keyStats?.rating != null &&
          //                 keyStats?.rating != 0 &&
          //                 showRating)
          //               Container(
          //                 margin: const EdgeInsets.only(top: 5),
          //                 child: RatingBar.builder(
          //                   initialRating: keyStats?.rating / 1,
          //                   minRating: 1,
          //                   direction: Axis.horizontal,
          //                   allowHalfRating: true,
          //                   itemCount: 5,
          //                   ignoreGestures: true,
          //                   itemSize: 16,
          //                   unratedColor: ThemeColors.greyBorder,
          //                   itemPadding:
          //                       const EdgeInsets.symmetric(horizontal: 0.0),
          //                   itemBuilder: (context, _) => const Icon(
          //                     Icons.star,
          //                     color: ThemeColors.accent,
          //                   ),
          //                   onRatingUpdate: (rating) {
          //                     print(rating);
          //                   },
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SdTopWidgetDetail(),
          SpacerVertical(height: 4),
          SdTopDisclaimer(),
          SpacerVertical(height: 4),
        ],
      ),
    );
  }
}
