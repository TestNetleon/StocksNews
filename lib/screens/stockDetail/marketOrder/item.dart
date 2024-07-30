// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/theme.dart';
// import '../../../widgets/cache_network_image.dart';
// import '../../../widgets/spacer_vertical.dart';

// class SdMarketOrderItem extends StatelessWidget {
//   const SdMarketOrderItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Navigator.push(
//         //   navigatorKey.currentContext!,
//         //   MaterialPageRoute(
//         //     builder: (_) => const StockDetail(symbol: "AAPL"),
//         //   ),
//         // );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           color: ThemeColors.background,
//           border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.6)),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 ClipRRect(
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     width: 48,
//                     height: 48,
//                     child: const CachedNetworkImagesWidget(
//                       "",
//                       placeHolder: Images.placeholder,
//                     ),
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "AAPL",
//                         style: styleGeorgiaBold(fontSize: 18),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SpacerVertical(height: 5),
//                       Text(
//                         // widget.data.name,
//                         "Apple Inc",

//                         style: styleGeorgiaRegular(
//                           color: ThemeColors.greyText,
//                           fontSize: 14,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       // const SpacerVertical(height: 5),
//                       // Row(
//                       //   children: [
//                       //     RichText(
//                       //       text: TextSpan(
//                       //         children: [
//                       //           TextSpan(
//                       //             text:
//                       //                 // "Mentions: ${widget.data.mention?.toInt()} ",
//                       //                 "Mentions: 340 ",
//                       //             style: stylePTSansRegular(fontSize: 12),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ),
//                       //     Flexible(
//                       //       child: RichText(
//                       //         text: TextSpan(
//                       //           children: [
//                       //             TextSpan(
//                       //               text:
//                       //                   // "(${widget.data.mentionChange.toCurrency()}%)",
//                       //                   "(3.4%)",
//                       //               style: stylePTSansRegular(
//                       //                 fontSize: 12,
//                       //                 // color: widget.data.mentionChange >= 0
//                       //                 //     ? ThemeColors.accent
//                       //                 //     : ThemeColors.sos,
//                       //                 color: ThemeColors.sos,
//                       //               ),
//                       //             ),
//                       //           ],
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       // widget.data.price ?? "",
//                       "\$34.3",

//                       style: stylePTSansBold(fontSize: 18),
//                     ),
//                     const SpacerVertical(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text:
//                                 // "${widget.data.displayChange} (${widget.data.changesPercentage.toCurrency()}%)",
//                                 "2.2 (1.22%)",
//                             style: stylePTSansRegular(
//                               fontSize: 14,
//                               // color: widget.data.changesPercentage > 0
//                               //     ? Colors.green
//                               //     : Colors.red,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const Divider(
//               color: ThemeColors.greyBorder,
//               height: 30,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Text(
//                         "Invested",
//                         style: stylePTSansRegular(
//                           fontSize: 14,
//                           color: ThemeColors.greyText,
//                         ),
//                       ),
//                       const SpacerVertical(height: 4),
//                       Text(
//                         "\$4.99",
//                         style: stylePTSansBold(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 35),
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Text(
//                         "Current",
//                         style: stylePTSansRegular(
//                           fontSize: 14,
//                           color: ThemeColors.greyText,
//                         ),
//                       ),
//                       const SpacerVertical(height: 4),
//                       Text(
//                         "\$4.77",
//                         style: stylePTSansBold(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 35),
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Text(
//                         "QTY",
//                         style: stylePTSansRegular(
//                           fontSize: 14,
//                           color: ThemeColors.greyText,
//                         ),
//                       ),
//                       const SpacerVertical(height: 4),
//                       Text(
//                         "0.99",
//                         style: stylePTSansBold(fontSize: 14),
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
