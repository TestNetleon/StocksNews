// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/screens/affiliate/leaderboard/widgets/item.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../modals/affiliate/refer_friend_res.dart';
// import '../../../providers/leaderboard.dart';
// import 'widgets/top_item.dart';

// class AffiliateLeaderBoard extends StatefulWidget {
//   const AffiliateLeaderBoard({super.key});

//   @override
//   State<AffiliateLeaderBoard> createState() => _AffiliateLeaderBoardState();
// }

// class _AffiliateLeaderBoardState extends State<AffiliateLeaderBoard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _callAPI();
//     });
//   }

//   _callAPI() {
//     LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
//     provider.getLeaderBoardData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();

//     return BaseUiContainer(
//       hasData: !provider.isLoadingL &&
//           (provider.leaderBoard?.isNotEmpty == true &&
//               provider.leaderBoard != null),
//       isLoading: provider.isLoadingL,
//       error: provider.errorL,
//       showPreparingText: true,
//       isFull: true,
//       child: CommonRefreshIndicator(
//         onRefresh: () async {
//           provider.getLeaderBoardData();
//         },
//         child: ListView.separated(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           itemBuilder: (context, listIndex) {
//             AffiliateReferRes? data = provider.leaderBoard?[listIndex];

//             // AffiliateReferRes? data = listData[listIndex];

//             if (listIndex == 0) {
//               return Column(
//                 children: [
//                   const SizedBox(
//                     // height: 300,
//                     width: double.infinity,
//                     // color: ThemeColors.accent,
//                     child: Stack(
//                       children: [
//                         Positioned(
//                           left: 0,
//                           top: 80,
//                           child: LeaderBoardTopItem(index: 1),
//                         ),
//                         Positioned(
//                           right: 0,
//                           top: 80,
//                           child: LeaderBoardTopItem(index: 2),
//                         ),
//                         Align(
//                           alignment: Alignment.topCenter,
//                           child: LeaderBoardTopItem(index: 0),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Visibility(
//                     visible: (provider.leaderBoard?.length ?? 0) > 3,
//                     // visible: listData.length > 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Divider(
//                           color: ThemeColors.greyBorder,
//                           height: 15,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "RANKING",
//                               style: styleBaseRegular(
//                                   color: ThemeColors.greyBorder),
//                             ),
//                             Text(
//                               "POINTS",
//                               style: styleBaseRegular(
//                                   color: ThemeColors.greyBorder),
//                             ),
//                           ],
//                         ),
//                         const Divider(
//                           color: ThemeColors.greyBorder,
//                           height: 15,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             }
//             if (listIndex == 1 || listIndex == 2) {
//               return const SizedBox();
//             }

//             return AffiliateLeaderBoardItem(
//               index: listIndex,
//               data: data,
//             );
//           },
//           separatorBuilder: (context, index) {
//             return index == 0 || index == 1 || index == 2
//                 ? const SizedBox()
//                 : const SpacerVertical(height: 10);
//           },
//           itemCount: provider.leaderBoard?.length ?? 0,
//           // itemCount: listData.length,
//         ),
//       ),
//     );
//   }
// }
