// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/my_evaluvated_button.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class NewMembershipUpgradeCurrentPlan extends StatefulWidget {
//   const NewMembershipUpgradeCurrentPlan({super.key});

//   @override
//   State<NewMembershipUpgradeCurrentPlan> createState() =>
//       _NewMembershipUpgradeCurrentPlanState();
// }

// class _NewMembershipUpgradeCurrentPlanState
//     extends State<NewMembershipUpgradeCurrentPlan> {
//   List<bool> isSelectedList = List.generate(3, (_) => false);
//   int selectedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       // crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
//           child: Text.rich(
//             softWrap: true,
//             textAlign: TextAlign.start,
//             TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Become a stocks.news ',
//                   style: stylePTSansBold(fontSize: 26, color: Colors.white),
//                 ),
//                 TextSpan(
//                   text: 'premium member',
//                   style: stylePTSansBold(
//                       fontSize: 26,
//                       color: const Color.fromARGB(255, 78, 252, 101)),
//                 ),
//                 TextSpan(
//                   text: ' for \$19.99 a month',
//                   style: stylePTSansBold(fontSize: 26, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SpacerVertical(
//           height: 10,
//         ),
//         Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {});
//               },
//               child: Container(
//                   width: MediaQuery.of(context).size.width / 1.05,
//                   decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         stops: [0.2, 0.65],
//                         colors: [
//                           Color.fromARGB(255, 32, 128, 65),
//                           Color.fromARGB(255, 22, 22, 22),
//                         ],
//                       ),
//                       border: Border.all(color: Colors.green),
//                       borderRadius: BorderRadius.circular(10.0)),
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             // width: 60,
//                             decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(10.0),
//                                     topRight: Radius.circular(10.0),
//                                     bottomLeft: Radius.circular(10.0))),
//                             padding: const EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Text(
//                                 'Premium member',
//                                 style: stylePTSansBold(
//                                     fontSize: 16, color: Colors.black),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '\$19.99/month',
//                             style: stylePTSansBold(
//                                 fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                       const SpacerVertical(
//                         height: 10,
//                       ),
//                       const SpacerVertical(
//                         height: 10,
//                       ),
//                       const SpacerVertical(
//                         height: 15,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 height: 20,
//                                 width: 20,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: ThemeColors.white,
//                                 ),
//                                 // padding: const EdgeInsets.all(8),
//                                 child: const Center(
//                                     child: Icon(
//                                   Icons.check,
//                                   color: Colors.green,
//                                   size: 16,
//                                 )),
//                               ),
//                               const SpacerHorizontal(
//                                 width: 6,
//                               ),
//                               Text(
//                                 ' Get More with Membership!',
//                                 style: stylePTSansRegular(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                             ],
//                           ),
//                           const SpacerVertical(
//                             height: 20,
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 height: 20,
//                                 width: 20,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: ThemeColors.white,
//                                 ),
//                                 // padding: const EdgeInsets.all(8),
//                                 child: const Center(
//                                     child: Icon(
//                                   Icons.check,
//                                   color: Colors.green,
//                                   size: 16,
//                                 )),
//                               ),
//                               const SpacerHorizontal(
//                                 width: 6,
//                               ),
//                               Text(
//                                 'Add Stocks to Alerts and Watchlist',
//                                 style: stylePTSansRegular(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                             ],
//                           ),
//                           const SpacerVertical(
//                             height: 20,
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 height: 20,
//                                 width: 20,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: ThemeColors.white,
//                                 ),
//                                 // padding: const EdgeInsets.all(8),
//                                 child: const Center(
//                                     child: Icon(
//                                   Icons.check,
//                                   color: Colors.green,
//                                   size: 16,
//                                 )),
//                               ),
//                               const SpacerHorizontal(
//                                 width: 6,
//                               ),
//                               Text(
//                                 'Access Market Data',
//                                 style: stylePTSansRegular(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                             ],
//                           ),
//                           const SpacerVertical(
//                             height: 20,
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 35.0),
//                                 child: Container(
//                                   height: 20,
//                                   width: 20,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: ThemeColors.white,
//                                   ),
//                                   // padding: const EdgeInsets.all(8),
//                                   child: const Center(
//                                       child: Icon(
//                                     Icons.check,
//                                     color: Colors.green,
//                                     size: 16,
//                                   )),
//                                 ),
//                               ),
//                               const SpacerHorizontal(
//                                 width: 6,
//                               ),
//                               Expanded(
//                                 child: Text.rich(
//                                   softWrap: true,
//                                   textAlign: TextAlign.start,
//                                   TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Unlock ',
//                                         style: stylePTSansRegular(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             ' MORNINGSTAR Reports” “Insider  Trades” “Congressional Trades” “High/Low PE” “Compare Stocks”',
//                                         style: stylePTSansBold(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       TextSpan(
//                                         text: ' and much more!',
//                                         style: stylePTSansRegular(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SpacerVertical(
//                             height: 20,
//                           ),
//                           MyElevatedButton(
//                             width: double.infinity,
//                             onPressed: () {},
//                             borderRadius: BorderRadius.circular(10),
//                             child: Text(
//                               'Continue',
//                               style: stylePTSansBold(
//                                   fontSize: 16, color: Colors.white),
//                             ),
//                           ),
//                           const SpacerVertical(
//                             height: 10,
//                           ),
//                           Center(
//                             child: Text(
//                               'Cancel anytime, Secured by App store',
//                               textAlign: TextAlign.center,
//                               style: stylePTSansRegular(
//                                   fontSize: 12, color: Colors.grey),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   )),
//             ),
//             const SpacerVertical(
//               height: 10,
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }
