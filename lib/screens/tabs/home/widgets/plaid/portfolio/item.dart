import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class HomePlaidItem extends StatelessWidget {
//   final PlaidDataRes data;
//   const HomePlaidItem({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               child: Container(
//                 width: 43,
//                 height: 43,
//                 padding: const EdgeInsets.all(5),
//                 child: CachedNetworkImagesWidget(
//                   data.image,
//                   // width: 30,
//                   // height: 30,
//                 ),
//               ),
//             ),
//             const SpacerHorizontal(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${data.tickerSymbol}",
//                     style: stylePTSansBold(fontSize: 14),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SpacerVertical(height: 5),
//                   Visibility(
//                     visible: data.name != null && data.name != '',
//                     child: Text(
//                       "${data.name}",
//                       style: stylePTSansRegular(
//                         color: ThemeColors.greyText,
//                         fontSize: 12,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SpacerHorizontal(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "\$${data.closePrice}",
//                   style: stylePTSansBold(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SpacerVertical(height: 5),
//                 // Text(
//                 //   "${data.displayChange} (${data.changesPercentage})%",
//                 //   style: stylePTSansRegular(
//                 //     fontSize: 12,
//                 //     color: data.changesPercentage > 0
//                 //         ? ThemeColors.accent
//                 //         : Colors.red,
//                 //   ),
//                 // ),
//               ],
//             ),
//           ],
//         ),
//         const SpacerVertical(height: 10),
//         Visibility(
//           visible: data.closePriceAsOf != "" && data.closePriceAsOf != null,
//           child: Text(
//             "Close price as of: ${data.closePriceAsOf ?? "N/A"}",
//             style: stylePTSansRegular(
//               color: ThemeColors.greyText,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Visibility(
//           visible: data.type != "" && data.type != null,
//           child: Text(
//             "${data.type ?? "N/A"}",
//             style: stylePTSansRegular(
//               color: ThemeColors.greyText,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

class HomePlaidItem extends StatelessWidget {
  final PlaidDataRes? data;
  const HomePlaidItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              child: Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(5),
                child: CachedNetworkImagesWidget(
                  data?.image,
                ),
              ),
            ),
            const SpacerHorizontal(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data?.tickerSymbol}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Visibility(
                    visible: data?.name != null && data?.name != '',
                    child: Text(
                      "${data?.name}",
                      style: stylePTSansRegular(
                        color: ThemeColors.greyText,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Visibility(
            visible: (data?.type != '' && data?.type != null) ||
                (data?.closePriceAsOf != "" && data?.closePriceAsOf != null),
            child: const SpacerVertical(height: 20)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: data?.type != '' && data?.type != null,
                child: Text(
                  data?.type.toString().capitalizeWords() ?? "",
                  style: stylePTSansRegular(),
                ),
              ),
              Visibility(
                visible:
                    data?.closePriceAsOf != "" && data?.closePriceAsOf != null,
                child: Text(
                  "Close price as of: ${data?.closePriceAsOf ?? "N/A"}",
                  style: stylePTSansRegular(
                    color: ThemeColors.greyText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
