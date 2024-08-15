// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import 'title_tag.dart';

// class StockHighlight extends StatelessWidget {
//   const StockHighlight({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Text('Stock highlight', style: stylePTSansBold(fontSize: 18.0)),
//         // const SpacerVertical(
//         //   height: 10.0,
//         // ),
//         const MsTitle(title: "Stock Highlights"),

//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//               children: List.generate(
//             4,
//             (index) {
//               return Container(
//                 constraints: const BoxConstraints(
//                   maxWidth: 200,
//                 ),
//                 decoration: BoxDecoration(
//                   // color: Color.fromARGB(255, 48, 47, 47),
//                   border:
//                       Border.all(color: ThemeColors.accent.withOpacity(0.5)),
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color.fromARGB(255, 0, 0, 0),
//                       Color.fromARGB(255, 2, 58, 9),
//                     ],
//                   ),
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //     color: ThemeColors.white,
//                   //     spreadRadius: 0.5,
//                   //     blurRadius: 2,
//                   //    ),
//                   // ],
//                 ),
//                 margin: const EdgeInsets.only(right: 10),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 13,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Stock Sentiment',
//                           style: stylePTSansRegular(
//                             fontSize: 18.0,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SpacerHorizontal(width: 8.0),
//                         const Icon(Icons.ac_unit_rounded, size: 18)
//                       ],
//                     ),
//                     const SpacerVertical(height: 8.0),
//                     Text(
//                       'Bullish',
//                       style: stylePTSansBold(
//                         fontSize: 18.0,
//                         color: Colors.green,
//                       ),
//                     ),
//                     const SpacerVertical(height: 8.0),
//                     Text(
//                       'Buyers are optimized about the price rise, Stock is up trend',
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       style: stylePTSansRegular(
//                         fontSize: 14.0,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           )),
//         )

//         // SizedBox(
//         //   height: 160,
//         //   child: ListView.builder(
//         //       itemCount: 4,
//         //       scrollDirection: Axis.horizontal,
//         //       // padding: const EdgeInsets.all(8.0),
//         //       shrinkWrap: true,
//         //       physics: const AlwaysScrollableScrollPhysics(),
//         //       itemBuilder: (context, index) {
//         //         return Container(
//         //           decoration: BoxDecoration(
//         //             color: Color.fromARGB(255, 48, 47, 47),
//         //             borderRadius: BorderRadius.circular(12),
//         //           ),
//         //           margin: const EdgeInsets.only(right: 8.0),
//         //           padding: const EdgeInsets.symmetric(
//         //             vertical: 8,
//         //             horizontal: 12,
//         //           ),
//         //           child: Column(
//         //             crossAxisAlignment: CrossAxisAlignment.start,
//         //             children: [
//         //               const SpacerVertical(height: 5.0),
//         //               Row(
//         //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                 children: [
//         //                   Text('Stock Sentiment',
//         //                       style: stylePTSansRegular(
//         //                           fontSize: 18.0, color: Colors.grey)),
//         //                   const SpacerHorizontal(
//         //                     width: 8.0,
//         //                   ),
//         //                   const Icon(Icons.ac_unit_rounded)
//         //                 ],
//         //               ),
//         //               const SpacerVertical(height: 8.0),
//         //               Text(
//         //                 'Bullish',
//         //                 style: stylePTSansBold(
//         //                   fontSize: 18.0,
//         //                   color: Colors.green,
//         //                 ),
//         //               ),
//         //               const SpacerVertical(
//         //                 height: 8.0,
//         //               ),
//         //               SizedBox(
//         //                 width: 180,
//         //                 child: Text(
//         //                   'Buyers are optimized about the price rise, Stock is up trend',
//         //                   maxLines: 3,
//         //                   overflow: TextOverflow.fade,
//         //                   style: stylePTSansRegular(
//         //                     fontSize: 18.0,
//         //                     color: Colors.grey,
//         //                   ),
//         //                 ),
//         //               ),
//         //             ],
//         //           ),
//         //         );
//         //       }),
//         // )
//       ],
//     );
//   }
// }
