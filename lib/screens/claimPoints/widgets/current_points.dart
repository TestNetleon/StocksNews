// // import 'package:animated_flip_counter/animated_flip_counter.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // import '../../../providers/missions/provider.dart';
// // import '../../../utils/colors.dart';
// // import '../../../utils/theme.dart';
// // import '../../../widgets/spacer_horizontal.dart';

// // class CurrentPointsItem extends StatelessWidget {
// //   const CurrentPointsItem({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     MissionProvider provider = context.watch<MissionProvider>();

// //     return Material(
// //       elevation: 5,
// //       borderRadius: BorderRadius.circular(8),
// //       child: Container(
// //         width: double.infinity,
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //         decoration: BoxDecoration(
// //           border: Border.all(color: const Color.fromARGB(255, 43, 43, 43)),
// //           borderRadius: BorderRadius.circular(8),
// //           gradient: const LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             stops: [0.3, 0.5, 0.8],
// //             transform: GradientRotation(1),
// //             colors: [
// //               Color.fromARGB(255, 0, 0, 0),
// //               Color.fromARGB(255, 39, 39, 39),
// //               Color.fromARGB(255, 0, 0, 0),
// //             ],
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   provider.extra?.title ?? "",
// //                   style: styleBaseBold(
// //                     fontSize: 30,
// //                   ),
// //                 ),
// //                 Text(
// //                   provider.extra?.subTitle ?? "",
// //                   style: styleBaseRegular(
// //                     fontSize: 14,
// //                     color: ThemeColors.greyText,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SpacerHorizontal(width: 5),
// //             Text(
// //               "${provider.extra?.balance ?? 0}",
// //               style: styleBaseBold(
// //                 fontSize: 40,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:animated_flip_counter/animated_flip_counter.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/missions/provider.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/theme.dart';
// import '../../../widgets/spacer_horizontal.dart';

// class CurrentPointsItem extends StatefulWidget {
//   const CurrentPointsItem({super.key});

//   @override
//   State<CurrentPointsItem> createState() => _CurrentPointsItemState();
// }

// class _CurrentPointsItemState extends State<CurrentPointsItem> {
//   @override
//   Widget build(BuildContext context) {
//     MissionProvider provider = context.watch<MissionProvider>();

//     return Material(
//       elevation: 5,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color.fromARGB(255, 43, 43, 43)),
//           borderRadius: BorderRadius.circular(8),
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: [0.3, 0.5, 0.8],
//             transform: GradientRotation(1),
//             colors: [
//               Color.fromARGB(255, 0, 0, 0),
//               Color.fromARGB(255, 39, 39, 39),
//               Color.fromARGB(255, 0, 0, 0),
//             ],
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     provider.extra?.title ?? "",
//                     style: styleBaseBold(
//                       fontSize: 30,
//                     ),
//                   ),
//                   Text(
//                     provider.extra?.subTitle ?? "",
//                     style: styleBaseRegular(
//                       fontSize: 14,
//                       color: ThemeColors.greyText,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SpacerHorizontal(width: 5),
//             AnimatedFlipCounter(
//               value: provider.extra?.balance ?? 0,
//               textStyle: styleBaseBold(
//                 fontSize: 40,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
