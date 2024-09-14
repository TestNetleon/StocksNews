// import 'package:flutter/material.dart';
// import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class MissionsItem extends StatelessWidget {
//   const MissionsItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: ThemeColors.background,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(Dimen.padding),
//         child: Row(
//           children: [
//             Image.asset(
//               Images.stockIcon,
//               width: 50,
//             ),
//             const SpacerHorizontal(width: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Daily Login",
//                   style: stylePTSansBold(),
//                 ),
//                 const SpacerVertical(height: 5),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 60,
//                       height: 5,
//                       child: FAProgressBar(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(5)),
//                         currentValue: 70,
//                         displayTextStyle: styleGeorgiaBold(
//                             color: ThemeColors.progressbackgroundColor),
//                         displayText: '',
//                         animatedDuration: const Duration(milliseconds: 0),
//                         progressColor: ThemeColors.progressbackgroundColor,
//                         backgroundColor: ThemeColors.greyBorder,
//                       ),
//                     ),
//                     const SpacerHorizontal(width: 10),
//                     Text(
//                       "84",
//                       style: stylePTSansRegular(fontSize: 12),
//                     ),
//                     Text(
//                       " / 50",
//                       style: stylePTSansRegular(fontSize: 12),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const SpacerHorizontal(width: 10),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: ThemeColors.background,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 37, 37, 37)
//                                     .withOpacity(0.5), // Shadow color
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 10),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(
//                                   Icons.ads_click_sharp,
//                                   size: 14,
//                                   color: ThemeColors.accent,
//                                 ),
//                                 const SpacerHorizontal(width: 5),
//                                 Text(
//                                   "10",
//                                   style: stylePTSansRegular(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SpacerHorizontal(width: 5),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: ThemeColors.background,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 37, 37, 37)
//                                     .withOpacity(0.5), // Shadow color
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 10),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(
//                                   Icons.star,
//                                   size: 14,
//                                   color: ThemeColors.ratingIconColor,
//                                 ),
//                                 const SpacerHorizontal(width: 5),
//                                 Text(
//                                   "25",
//                                   style: stylePTSansRegular(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//                 // const SpacerVertical(height: 10),
//                 // Row(
//                 //   children: [
//                 //     Container(
//                 //       decoration: BoxDecoration(
//                 //         borderRadius: BorderRadius.circular(10),
//                 //         color: ThemeColors.background,
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //             color: const Color.fromARGB(255, 37, 37, 37)
//                 //                 .withOpacity(0.5), // Shadow color
//                 //             spreadRadius: 2,
//                 //             blurRadius: 5,
//                 //             offset: const Offset(0, 1),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.symmetric(
//                 //             vertical: 5, horizontal: 10),
//                 //         child: Row(
//                 //           mainAxisSize: MainAxisSize.min,
//                 //           children: [
//                 //             const Icon(
//                 //               Icons.circle,
//                 //               size: 14,
//                 //               color: ThemeColors.accent,
//                 //             ),
//                 //             const SpacerHorizontal(width: 5),
//                 //             Text(
//                 //               "10",
//                 //               style: stylePTSansRegular(fontSize: 12),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     const SpacerHorizontal(width: 10),
//                 //     Container(
//                 //       decoration: BoxDecoration(
//                 //         borderRadius: BorderRadius.circular(10),
//                 //         color: ThemeColors.background,
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //             color: const Color.fromARGB(255, 37, 37, 37)
//                 //                 .withOpacity(0.5), // Shadow color
//                 //             spreadRadius: 2,
//                 //             blurRadius: 5,
//                 //             offset: const Offset(0, 1),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.symmetric(
//                 //             vertical: 5, horizontal: 10),
//                 //         child: Row(
//                 //           mainAxisSize: MainAxisSize.min,
//                 //           children: [
//                 //             const Icon(
//                 //               Icons.star,
//                 //               size: 14,
//                 //               color: ThemeColors.ratingIconColor,
//                 //             ),
//                 //             const SpacerHorizontal(width: 5),
//                 //             Text(
//                 //               "25",
//                 //               style: stylePTSansRegular(fontSize: 12),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //     )
//                 //   ],
//                 // )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
