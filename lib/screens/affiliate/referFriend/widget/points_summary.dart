// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/leaderboard.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/cache_network_image.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import '../../../../utils/colors.dart';
// import '../../../../utils/constants.dart';
// import '../../pointsTransaction/trasnsaction.dart';
// import '../../seperatePoints/index.dart';

// // import '../../../../utils/colors.dart';
// // import '../../../../utils/constants.dart';
// // import '../../pointsTransaction/trasnsaction.dart';

// class PointsSummary extends StatelessWidget {
//   const PointsSummary({
//     super.key,
//     this.fromDrawer = true,
//   });
//   final bool fromDrawer;
//   @override
//   Widget build(BuildContext context) {
//     LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
//     return Visibility(
//       visible: (provider.extra?.totalActivityPoints ?? 0) != 0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!fromDrawer)
//             Text(
//               "Points Summary",
//               style: styleBaseBold(fontSize: 25),
//             ),
//           if (!fromDrawer) const SpacerVertical(height: 15),
//           Visibility(
//             visible: provider.extra?.pointsSummary != null &&
//                 provider.extra?.pointsSummary?.isNotEmpty == true,
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: const Color.fromARGB(255, 17, 17, 17),
//                 border: Border.all(
//                   color: const Color.fromARGB(255, 29, 29, 29),
//                 ),
//               ),
//               child: ListView.separated(
//                 padding: EdgeInsets.fromLTRB(
//                   20,
//                   15,
//                   20,
//                   fromDrawer ? 10 : 20,
//                 ),
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   if (index == 0) {
//                     return Column(
//                       children: [
//                         PointSummaryItem(
//                           tnxType:
//                               provider.extra?.pointsSummary?[index].txnType ??
//                                   "",
//                           icon: CachedNetworkImagesWidget(
//                               provider.extra?.pointsSummary?[index].icon ?? "",
//                               width: 24),
//                           label:
//                               provider.extra?.pointsSummary?[index].text ?? "",
//                           value:
//                               "${provider.extra?.pointsSummary?[index].value ?? 0}",
//                         ),
//                         Visibility(
//                           visible: provider.verified != 0 ||
//                               provider.unVerified != 0,
//                           child: Container(
//                             margin: const EdgeInsets.only(top: 10),
//                             alignment: Alignment.centerLeft,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Visibility(
//                                   visible: provider.verified != 0,
//                                   child: Container(
//                                     margin: const EdgeInsets.only(
//                                       right: 5,
//                                     ),
//                                     child: Text(
//                                       "Verified: ${provider.verified}${provider.unVerified != 0 ? "," : ""}",
//                                       style: styleBaseRegular(
//                                         color: ThemeColors.accent,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Visibility(
//                                   visible: provider.unVerified != 0,
//                                   child: Text(
//                                     "Unverified: ${provider.unVerified}",
//                                     style: styleBaseRegular(
//                                       color: ThemeColors.sos,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }

//                   return PointSummaryItem(
//                     tnxType:
//                         provider.extra?.pointsSummary?[index].txnType ?? "",
//                     icon: CachedNetworkImagesWidget(
//                         provider.extra?.pointsSummary?[index].icon ?? "",
//                         width: 24),
//                     label: provider.extra?.pointsSummary?[index].text ?? "",
//                     value:
//                         "${provider.extra?.pointsSummary?[index].value ?? 0}",
//                   );
//                 },
//                 separatorBuilder: (context, index) {
//                   // Check if the index is the last item in the list
//                   // if (index ==
//                   //     (provider.extra?.pointsSummary?.length ?? 0) - 1) {
//                   //   return SizedBox.shrink();
//                   // }

//                   return Divider(
//                     color: Color.fromARGB(255, 56, 56, 56),
//                     height: 25,
//                   );
//                 },
//                 itemCount: provider.extra?.pointsSummary?.length ?? 0,
//               ),
//             ),
//           ),

//           // child: Column(
//           //   crossAxisAlignment: CrossAxisAlignment.start,
//           //   children: [
//           //     Padding(
//           //       padding: const EdgeInsets.fromLTRB(
//           //         20,
//           //         15,
//           //         20,
//           //         20,
//           //       ),
//           //       child: Column(
//           //         children: [
//           //           PointSummaryItem(
//           //             icon: Image.asset(Images.referPoint, width: 24),
//           //             label: "Referral Points",
//           //             value: "${provider.data?.length ?? 0}",
//           //           ),
//           //           Visibility(
//           //             visible: provider.verified != 0 ||
//           //                 provider.unVerified != 0,
//           //             child: Container(
//           //               margin: const EdgeInsets.only(top: 10),
//           //               alignment: Alignment.centerLeft,
//           //               child: Row(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 children: [
//           //                   Visibility(
//           //                     visible: provider.verified != 0,
//           //                     child: Container(
//           //                       margin: const EdgeInsets.only(
//           //                         right: 5,
//           //                       ),
//           //                       child: Text(
//           //                         "Verified: ${provider.verified}${provider.unVerified != 0 ? "," : ""}",
//           //                         style: styleBaseRegular(
//           //                           color: ThemeColors.accent,
//           //                         ),
//           //                       ),
//           //                     ),
//           //                   ),
//           //                   Visibility(
//           //                     visible: provider.unVerified != 0,
//           //                     child: Text(
//           //                       "Unverified: ${provider.unVerified}",
//           //                       style: styleBaseRegular(
//           //                         color: ThemeColors.sos,
//           //                       ),
//           //                     ),
//           //                   ),
//           //                 ],
//           //               ),
//           //             ),
//           //           ),
//           //           const Divider(
//           //             color: Color.fromARGB(255, 56, 56, 56),
//           //             height: 25,
//           //           ),
//           //           PointSummaryItem(
//           //             icon: Container(
//           //               height: 24,
//           //               width: 24,
//           //               padding: const EdgeInsets.all(2),
//           //               child: Image.asset(
//           //                 Images.activityPoints,
//           //                 width: 22,
//           //                 color: Colors.amber,
//           //               ),
//           //             ),
//           //             label: "Activity Points",
//           //             value: "${provider.extra?.totalActivityPoints ?? 0}",
//           //           ),
//           //           const Divider(
//           //             color: Color.fromARGB(255, 56, 56, 56),
//           //             height: 25,
//           //           ),
//           //           PointSummaryItem(
//           //             icon: Image.asset(
//           //               Images.totalPoint,
//           //               width: 24,
//           //               color: Colors.amber,
//           //             ),
//           //             label: "Total Points",
//           //             value: "${provider.extra?.received ?? 0}",
//           //           ),
//           //           const Divider(
//           //             color: Color.fromARGB(255, 56, 56, 56),
//           //             height: 25,
//           //           ),
//           //           PointSummaryItem(
//           //             icon: Image.asset(
//           //               Images.pointSpent,
//           //               width: 24,
//           //               color: Colors.red,
//           //             ),
//           //             label: "Points Spent",
//           //             value: "${provider.extra?.spent ?? 0}",
//           //           ),
//           //           const Divider(
//           //             color: Color.fromARGB(255, 56, 56, 56),
//           //             height: 25,
//           //           ),
//           //           PointSummaryItem(
//           //             icon: Image.asset(Images.totalPoints, width: 24),
//           //             label: "Balance Points",
//           //             value: "${provider.extra?.balance ?? 0}",
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //     if (!fromDrawer)
//           //       GestureDetector(
//           //         onTap: () => Navigator.push(
//           //           context,
//           //           MaterialPageRoute(
//           //             builder: (context) => const AffiliateTransaction(),
//           //           ),
//           //         ),
//           //         child: Container(
//           //           padding: const EdgeInsets.symmetric(
//           //             horizontal: 0,
//           //             vertical: 12,
//           //           ),
//           //           decoration: const BoxDecoration(
//           //             border: Border(
//           //               bottom: BorderSide(
//           //                 color: Color.fromARGB(255, 29, 29, 29),
//           //               ),
//           //               left: BorderSide(
//           //                 color: Color.fromARGB(255, 29, 29, 29),
//           //               ),
//           //               right: BorderSide(
//           //                 color: Color.fromARGB(255, 29, 29, 29),
//           //               ),
//           //             ),
//           //             color: Color.fromARGB(255, 25, 25, 25),
//           //             borderRadius: BorderRadius.only(
//           //               bottomLeft: Radius.circular(5),
//           //               bottomRight: Radius.circular(5),
//           //             ),
//           //           ),
//           //           child: Row(
//           //             mainAxisAlignment: MainAxisAlignment.center,
//           //             children: [
//           //               Image.asset(
//           //                 Images.transaction,
//           //                 height: 20,
//           //                 width: 20,
//           //                 color: ThemeColors.accent,
//           //               ),
//           //               const SpacerHorizontal(width: 5),
//           //               Flexible(
//           //                 child: Text(
//           //                   "View Points Transactions",
//           //                   style: styleBaseBold(
//           //                     fontSize: 16,
//           //                     color: ThemeColors.accent,
//           //                     decoration: TextDecoration.underline,
//           //                   ),
//           //                 ),
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       ),
//           //   ],
//           // ),

//           if (!fromDrawer)
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const AffiliateTransaction(),
//                 ),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 0,
//                   vertical: 12,
//                 ),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Color.fromARGB(255, 29, 29, 29),
//                     ),
//                     left: BorderSide(
//                       color: Color.fromARGB(255, 29, 29, 29),
//                     ),
//                     right: BorderSide(
//                       color: Color.fromARGB(255, 29, 29, 29),
//                     ),
//                   ),
//                   color: Color.fromARGB(255, 25, 25, 25),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(5),
//                     bottomRight: Radius.circular(5),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       Images.transaction,
//                       height: 20,
//                       width: 20,
//                       color: ThemeColors.accent,
//                     ),
//                     const SpacerHorizontal(width: 5),
//                     Flexible(
//                       child: Text(
//                         "View Points Transactions",
//                         style: styleBaseBold(
//                           fontSize: 16,
//                           color: ThemeColors.accent,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class PointSummaryItem extends StatelessWidget {
//   const PointSummaryItem({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.icon,
//     this.tnxType,
//   });

//   final String label;
//   final String value;
//   final String? tnxType;

//   final Widget icon;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (tnxType == null || tnxType == '') {
//           return;
//         }
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SeparatePointsIndex(
//               type: tnxType ?? "",
//               appbarHeading: "$label: $value",
//             ),
//           ),
//         );
//       },
//       child: Column(
//         children: [
//           Row(
//             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Icon(icon, color: Colors.green),
//               // Image.asset(icon, width: 24),
//               icon,
//               const SpacerHorizontal(width: 12),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: styleBaseRegular(fontSize: 17),
//                 ),
//               ),
//               const SpacerVertical(height: 10),
//               Text(
//                 value,
//                 style: styleBaseBold(fontSize: 17),
//               ),
//             ],
//           ),
//           // Visibility(
//           //   visible: tnxType != null && tnxType != '',
//           //   child: Align(
//           //     alignment: Alignment.centerRight,
//           //     child: ThemeButtonSmall(
//           //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//           //       fontBold: true,
//           //       showArrow: false,
//           //       radius: 30,
//           //       text: "View Transactions",
//           //       onPressed: () {
//           //         Navigator.push(
//           //           context,
//           //           MaterialPageRoute(
//           //             builder: (context) => SeparatePointsIndex(
//           //               type: tnxType ?? "",
//           //               appbarHeading: "$label: $value",
//           //             ),
//           //           ),
//           //         );
//           //       },
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
