// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/screens/affiliate/leaderboard/widgets/item.dart';
// import 'package:stocks_news_new/screens/leader_board_new.dart/leader_ship_new_top.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../modals/affiliate/refer_friend_res.dart';
// import '../../../providers/leaderboard.dart';

// class AffiliateLeaderBoardNew extends StatefulWidget {
//   const AffiliateLeaderBoardNew({super.key});

//   @override
//   State<AffiliateLeaderBoardNew> createState() =>
//       _AffiliateLeaderBoardNewState();
// }

// class _AffiliateLeaderBoardNewState extends State<AffiliateLeaderBoardNew> {
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

//             if (listIndex == 0) {
//               return Column(
//                 children: [
//                   const LeaderShipNewTop(),
//                   const SpacerVertical(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Text(
//                       "LeaderBoard",
//                       style: styleBaseBold(),
//                     ),
//                   ),
//                   const SpacerVertical(height: 10),
//                   Visibility(
//                     visible: (provider.leaderBoard?.length ?? 0) > 3,
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
