// import 'package:flutter/material.dart';

// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class BenefitTitle extends StatelessWidget {
//   final String? title;
//   final String? subTitle;
//   final String? text;

//   const BenefitTitle({
//     super.key,
//     this.title,
//     this.subTitle,
//     this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: (title != null && title != "") ||
//           (subTitle != null && subTitle != ""),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 12.0),
//             child: Image.asset(
//               Images.reward,
//               height: 80.0,
//               width: 100.0,
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SpacerVertical(height: 8),
//                 Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.topRight,
//                       stops: [0.3, 0.65],
//                       colors: [
//                         Color.fromARGB(255, 32, 128, 65),
//                         Color.fromARGB(255, 11, 85, 37),
//                       ],
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(8),
//                   child: Text(
//                     "$title",
//                     style: stylePTSansRegular(
//                       color: ThemeColors.white,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//                 const SpacerVertical(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5.0),
//                   child: Text(
//                     "$subTitle",
//                     style: stylePTSansRegular(
//                       color: ThemeColors.lightGreen,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 const SpacerVertical(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 5.0,
//                     right: 25.0,
//                   ),
//                   child: Text(
//                     "$text",
//                     style: stylePTSansRegular(
//                       color: ThemeColors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 const SpacerVertical(height: 8),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
