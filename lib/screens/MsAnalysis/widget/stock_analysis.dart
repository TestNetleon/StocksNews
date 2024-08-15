// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import 'title_tag.dart';

// class StockSubAnalysis extends StatelessWidget {
//   const StockSubAnalysis({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Shader textGradient = const LinearGradient(
//       colors: [
//         Color.fromARGB(255, 247, 204, 86),
//         Color.fromARGB(255, 245, 143, 47)
//       ],
//     ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Text(
//         //   'SWOT analysis',
//         //   style: stylePTSansBold(
//         //     fontSize: 18.0,
//         //     color: Colors.white,
//         //   ),
//         // ),
//         // const SpacerVertical(height: 8.0),
//         MsTitle(title: 'SWOT analysis'),

//         Container(
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 53, 53, 53),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(10.0),
//               topRight: Radius.circular(10.0),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: Column(
//               children: const [
//                 Row(
//                   children: [
//                     ItemSWOT(
//                       label: 'Strength',
//                       value: '6',
//                       keyword: 'S',
//                       bottom: 0,
//                       right: 0,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       childRadius: BorderRadius.only(
//                         topLeft: Radius.circular(100),
//                         bottomRight: Radius.circular(20),
//                       ),
//                     ),
//                     SpacerHorizontal(width: 10),
//                     ItemSWOT(
//                       label: 'Weakness',
//                       value: '6',
//                       keyword: 'W',
//                       bottom: 0,
//                       left: 0,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       childRadius: BorderRadius.only(
//                         topRight: Radius.circular(100),
//                         bottomLeft: Radius.circular(20),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SpacerVertical(height: 10),
//                 Row(
//                   children: [
//                     ItemSWOT(
//                       label: 'Opportunity',
//                       value: '6',
//                       keyword: 'O',
//                       top: 0,
//                       right: 0,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       childRadius: BorderRadius.only(
//                         topRight: Radius.circular(20),
//                         bottomLeft: Radius.circular(100),
//                       ),
//                     ),
//                     SpacerHorizontal(width: 10.0),
//                     ItemSWOT(
//                       label: 'Threat',
//                       value: '6',
//                       keyword: 'T',
//                       left: 0,
//                       top: 0,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       childRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(100),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           // width: MediaQuery.of(context).size.width * 0.96,
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 36, 32, 32),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(10.0),
//               bottomRight: Radius.circular(10.0),
//             ),
//           ),
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'View details',
//                     overflow: TextOverflow.fade,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w800,
//                       foreground: Paint()..shader = textGradient,
//                     ),
//                   ),
//                   const Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.orange,
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ItemSWOT extends StatelessWidget {
//   const ItemSWOT({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.keyword,
//     required this.childRadius,
//     required this.crossAxisAlignment,
//     this.left,
//     this.right,
//     this.top,
//     this.bottom,
//   });

//   final String label, value, keyword;
//   final double? left, top, right, bottom;
//   final BorderRadius childRadius;
//   final CrossAxisAlignment crossAxisAlignment;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           color: const Color.fromARGB(255, 102, 100, 100),
//         ),
//         child: Stack(
//           fit: StackFit.passthrough,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: crossAxisAlignment,
//                 children: [
//                   Text(
//                     label,
//                     style: stylePTSansBold(
//                       fontSize: 14.0,
//                       color: const Color.fromARGB(255, 195, 195, 195),
//                     ),
//                   ),
//                   const SpacerVertical(height: 8.0),
//                   Text(
//                     value,
//                     style: stylePTSansBold(
//                       fontSize: 14.0,
//                       color: ThemeColors.themeGreen,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: bottom,
//               right: right,
//               left: left,
//               top: top,
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: childRadius,
//                 ),
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.only(
//                   top: bottom == 0 ? 8.0 : 0,
//                   left: right == 0 ? 8.0 : 0,
//                   right: left == 0 ? 8.0 : 0,
//                   bottom: top == 0 ? 8.0 : 0,
//                 ),
//                 child: Text(
//                   keyword,
//                   style: stylePTSansBold(fontSize: 14.0, color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
