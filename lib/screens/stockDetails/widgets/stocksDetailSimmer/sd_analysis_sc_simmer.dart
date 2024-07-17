// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/simmer_effect_reddit_twitter.dart/reddit_twitter_item_sc_simmer.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
// import 'package:stocks_news_new/widgets/screen_title_simmer.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class StocksDetailAnalysisSimmer extends StatelessWidget {
//   const StocksDetailAnalysisSimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
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
//           const SpacerVertical(height: 20),
//           GradientContainerWidget(
//             height: 60,
//             borderRadius: 2.sp,
//           ),
//           const SpacerVertical(height: 10),
//           const Divider(
//             color: ThemeColors.accent,
//             height: 2,
//             thickness: 2,
//           ),
//           const SpacerVertical(
//             height: Dimen.itemSpacing,
//           ),
//           ListView.separated(
//             itemCount: 5,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemBuilder: (context, index) {
//               return GradientContainerWidget(
//                 height: 50,
//                 borderRadius: 2.sp,
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return const SpacerVertical(
//                 height: Dimen.itemSpacing,
//               );
//             },
//           ),
//           const SpacerVertical(
//             height: Dimen.itemSpacing,
//           ),
//           GradientContainerWidget(
//             height: 100,
//             borderRadius: 2.sp,
//           ),
//           const SpacerVertical(
//             height: Dimen.itemSpacing,
//           ),
//           const ScreenTitleSimmer(
//             titleVisible: false,
//           ),
//           const RedditTwitterItemScreenSimmer()
//         ],
//       ),
//     );
//   }
// }
