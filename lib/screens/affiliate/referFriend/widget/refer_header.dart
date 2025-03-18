// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/screens/affiliate/referFriend/widget/refer_card_header.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class ReferHeader extends StatelessWidget {
//   const ReferHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(
//           vertical: 8.0), // Optional: Adjust margin as needed
//       width: double.infinity,
//       // Set the height for the divider
//       decoration: const BoxDecoration(
//         color: ThemeColors.greyBorder,

//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight:
//                 Radius.circular(20)), // Adjust the border radius as needed
//       ),
//       padding: const EdgeInsets.only(bottom: 1),

//       child: Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20)),
//           color: ThemeColors.blackShade,
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: Dimen.padding, right: Dimen.padding),
//               child: Column(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(300),
//                     child: Image.asset(
//                       Images.refer,
//                       height: 200,
//                       width: 200,
//                     ),
//                   ),
//                   Text(
//                     "Refer and Earn",
//                     style: styleBaseBold(fontSize: 24),
//                   ),
//                   const SpacerVertical(height: 20),
//                   RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "Upto 50% commission* ",
//                           style: styleBaseBold(),
//                         ),
//                         TextSpan(
//                           text: "on fees for every buy and sell of coins. ",
//                           style: styleBaseRegular(),
//                         ),
//                         TextSpan(
//                           text: "T&C",
//                           style: styleBaseRegular(
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SpacerVertical(height: 20),
//             const ReferCardHeader(),
//             const SpacerVertical(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
