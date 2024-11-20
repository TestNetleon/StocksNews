// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/screens/tabs/home/membership/widgtes/custom_expantion_tile.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class NewMembershipFaq extends StatefulWidget {
//   const NewMembershipFaq({super.key});

//   @override
//   State<NewMembershipFaq> createState() => _NewMembershipFaqState();
// }

// class _NewMembershipFaqState extends State<NewMembershipFaq> {
//   // final bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Frequantly asked question',
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         const SpacerVertical(
//           height: 10,
//         ),
//         SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: MediaQuery.of(context).size.width / 1.08,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
//             padding: const EdgeInsets.only(top: 25.0, right: 20.0, left: 5.0),
//             // margin: const EdgeInsets.only(bottom: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(5, (index) {
//                 return Column(
//                   children: [
//                     const CustomExpansionTile(
//                       title: Padding(
//                         padding: EdgeInsets.only(right: 10.0),
//                         child: Text(
//                           "Will my subsricption be active on all platform?",
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700),
//                         ),
//                       ),
//                       children: [
//                         Text(
//                           'You can use the minLeadingWidth on your ListTile.',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SpacerVertical(
//                           height: 8.0,
//                         ),
//                         Text(
//                           'For those who are looking for a clean.',
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SpacerVertical(
//                           height: 8.0,
//                         ),
//                         Text(
//                           'In my case I used clipBehavior: Clip.antiAlias on card.',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SpacerVertical(
//                           height: 8.0,
//                         ),
//                         Text(
//                           'In my case I used clipBehavior: Clip.antiAlias on card.',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                     const SpacerVertical(
//                       height: 15.0,
//                     ),
//                     index == 4
//                         ? const SizedBox.shrink()
//                         : const Divider(
//                             color: ThemeColors.greyBorder,
//                             height: 10,
//                             indent: 20,
//                             endIndent: 8,
//                           ),
//                     const SpacerVertical(
//                       height: 15.0,
//                     )
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
