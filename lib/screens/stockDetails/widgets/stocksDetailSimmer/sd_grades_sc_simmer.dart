// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
// import 'package:stocks_news_new/widgets/screen_title_simmer.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class StocksDetailGradesSimmer extends StatelessWidget {
//   const StocksDetailGradesSimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SpacerVertical(),
//           Row(
//             children: [
//               const GradientContainerWidget(
//                 height: 43,
//                 width: 43,
//               ),
//               const SpacerHorizontal(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GradientContainerWidget(
//                     height: 20,
//                     borderRadius: 2.sp,
//                     width: 50.sp,
//                   ),
//                   const SpacerVertical(height: 5),
//                   GradientContainerWidget(
//                     height: 20,
//                     borderRadius: 2.sp,
//                     width: 100.sp,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SpacerVertical(height: 10),
//           GradientContainerWidget(
//             height: 40,
//             borderRadius: 2.sp,
//           ),
//           SpacerVertical(height: 20.sp),
//           const ScreenTitleSimmer(
//             titleVisible: false,
//             twoLineSubTitle: true,
//             leftPaddingSubTitle: 0,
//           ),
//           ListView.separated(
//             padding: EdgeInsets.zero,
//             itemCount: 3,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               return const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GradientContainerWidget(
//                     height: 20,
//                     width: 70,
//                   ),
//                   GradientContainerWidget(
//                     height: 20,
//                     width: 70,
//                   ),
//                 ],
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               // return const SpacerVertical(height: 12);
//               return Divider(
//                 color: ThemeColors.greyBorder,
//                 height: 20.sp,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
