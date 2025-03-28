import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ToolsItem extends StatelessWidget {
  final ToolsCardsRes? card;
  final Function()? onTap;
  const ToolsItem({super.key, this.card, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Pad.pad16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ThemeColors.neutral10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: card?.image != null && card?.image != '',
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: ThemeColors.neutral5,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12),
                child: CachedNetworkImage(
                  imageUrl: card?.image ?? '',
                  color: ThemeColors.black,
                ),
              ),
            ),
            SpacerHorizontal(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: card?.title != null && card?.title != '',
                    child: Text(
                      textAlign: TextAlign.center,
                      card?.title ?? '',
                      // style: styleBaseBold(fontSize: 22),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  Visibility(
                    visible: card?.subTitle != null && card?.subTitle != '',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        card?.subTitle ?? '',
                        style: styleBaseRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                          height: 1.3,
                        ),
                      ),
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

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/models/tools.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class ToolsItem extends StatelessWidget {
//   final ToolsCardsRes? card;
//   final Function()? onTap;
//   const ToolsItem({super.key, this.card, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(Pad.pad10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: ThemeColors.neutral10),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Visibility(
//               visible: card?.image != null && card?.image != '',
//               child: Container(
//                 height: 48,
//                 width: 48,
//                 margin: const EdgeInsets.only(top: 10),
//                 decoration: BoxDecoration(
//                   color: ThemeColors.neutral5,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.all(12),
//                 child: CachedNetworkImage(
//                   imageUrl: card?.image ?? '',
//                   color: ThemeColors.black,
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: card?.title != null && card?.title != '',
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Text(
//                   textAlign: TextAlign.center,
//                   card?.title ?? '',
//                   style: styleBaseBold(),
//                 ),
//               ),
//             ),
//             // Visibility(
//             //   visible: card?.subTitle != null && card?.subTitle != '',
//             //   child: Padding(
//             //     padding: const EdgeInsets.only(top: 8),
//             //     child: Text(
//             //       textAlign: TextAlign.center,
//             //       card?.subTitle ?? '',
//             //       style: styleBaseRegular(
//             //         fontSize: 16,
//             //         color: ThemeColors.neutral80,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             SpacerVertical(height: 10),
//             // BaseButton(
//             //   text: card?.buttonText ?? '',
//             //   onPressed: onTap,
//             //   color: ThemeColors.white,
//             //   textColor: ThemeColors.secondary120,
//             //   side: BorderSide(
//             //     color: ThemeColors.secondary120,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
