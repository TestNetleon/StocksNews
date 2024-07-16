// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class StocksHeaderDetailSimmer extends StatelessWidget {
//   const StocksHeaderDetailSimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SpacerVertical(),
//         Row(
//           children: [
//             const GradientContainerWidget(
//               height: 43,
//               width: 43,
//             ),
//             const SpacerHorizontal(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GradientContainerWidget(
//                   height: 20,
//                   borderRadius: 2.sp,
//                   width: 50.sp,
//                 ),
//                 const SpacerVertical(height: 5),
//                 GradientContainerWidget(
//                   height: 20,
//                   borderRadius: 2.sp,
//                   width: 100.sp,
//                 ),
//               ],
//             ),
//             const Expanded(child: SpacerHorizontal(width: 30)),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     GradientContainerWidget(
//                       height: 20,
//                       borderRadius: 2.sp,
//                       width: 30.sp,
//                     ),
//                     const SpacerVertical(height: 5),
//                     GradientContainerWidget(
//                       height: 20,
//                       borderRadius: 2.sp,
//                       width: 70.sp,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SpacerHorizontal(width: 10),
//           ],
//         ),
//         const SpacerVertical(height: 4),
//         Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GradientContainerWidget(
//                   height: 20,
//                   borderRadius: 2.sp,
//                   width: 160.sp,
//                 ),
//                 const SpacerVertical(height: 5),
//                 GradientContainerWidget(
//                   height: 20,
//                   borderRadius: 2.sp,
//                   width: 100.sp,
//                 ),
//               ],
//             ),
//             const Expanded(child: SpacerHorizontal(width: 30)),
//             const GradientContainerWidget(
//               height: 20,
//               width: 20,
//             ),
//             const SpacerHorizontal(width: 10),
//           ],
//         ),
//         const SpacerVertical(height: 20),
//         GradientContainerWidget(
//           height: 60.sp,
//           borderRadius: 2.sp,
//         ),
//       ],
//     );
//   }
// }
