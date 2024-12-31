import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/spacer_vertical.dart';
import '../../../modals/stock_details_res.dart';
import '../../../providers/stock_detail_new.dart';
import '../../../utils/colors.dart';
import 'overview/desclaimer.dart';
import 'overview/top_widget.dart';

class SdCommonHeading extends StatelessWidget {
  const SdCommonHeading({this.showRating = false, super.key});
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SdTopWidgetDetail(),
          const SpacerVertical(height: 4),
          const SdTopDisclaimer(),
          const SpacerVertical(height: 4),
          if (keyStats?.rating != null && keyStats?.rating != 0 && showRating)
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: RatingBar.builder(
                initialRating: keyStats?.rating / 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures: true,
                itemSize: 16,
                unratedColor: ThemeColors.greyBorder,
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: ThemeColors.accent,
                ),
                onRatingUpdate: (rating) {
                  // print(rating);
                },
              ),
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:provider/provider.dart';

// import '../../../../widgets/spacer_vertical.dart';
// import '../../../modals/stock_details_res.dart';
// import '../../../providers/stock_detail_new.dart';
// import '../../../utils/colors.dart';
// import 'overview/desclaimer.dart';
// import 'overview/top_widget.dart';

// class SdCommonHeading extends StatelessWidget {
//   const SdCommonHeading({this.showRating = false, super.key});
//   final bool showRating;

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     KeyStats? keyStats = provider.tabRes?.keyStats;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SdTopWidgetDetail(),
//           const SpacerVertical(height: 4),
//           const SdTopDisclaimer(),
//           const SpacerVertical(height: 4),
//           if (keyStats?.rating != null && keyStats?.rating != 0 && showRating)
//             Container(
//               margin: const EdgeInsets.only(top: 5),
//               child: RatingBar.builder(
//                 initialRating: keyStats?.rating / 1,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 ignoreGestures: true,
//                 itemSize: 16,
//                 unratedColor: ThemeColors.greyBorder,
//                 itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
//                 itemBuilder: (context, _) => const Icon(
//                   Icons.star,
//                   color: ThemeColors.accent,
//                 ),
//                 onRatingUpdate: (rating) {
//                   // print(rating);
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
