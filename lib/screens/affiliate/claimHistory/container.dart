// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/affiliate/transaction.dart';
// import 'package:stocks_news_new/providers/leaderboard.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/refresh_controll.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../pointsTransaction/trasnsaction.dart';

// class ClaimHistoryContainer extends StatelessWidget {
//   final String type;
//   final dynamic id;

//   const ClaimHistoryContainer({super.key, required this.type, this.id});

//   @override
//   Widget build(BuildContext context) {
//     LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
//     return BaseUiContainer(
//       error: provider.errorClaim,
//       hasData:
//           provider.dataClaim != null && provider.dataClaim?.isNotEmpty == true,
//       isLoading: provider.isLoadingClaim,
//       showPreparingText: true,
//       onRefresh: () => provider.getUnclaimedData(type: type, id: id),
//       child: RefreshControl(
//         onRefresh: () async =>
//             await provider.getUnclaimedData(type: type, id: id),
//         canLoadMore: provider.canLoadMoreClaim,
//         onLoadMore: () async =>
//             provider.getUnclaimedData(loadMore: true, type: type, id: id),
//         child: ListView.separated(
//           padding: EdgeInsets.fromLTRB(
//             Dimen.padding,
//             0,
//             Dimen.padding,
//             Dimen.padding,
//           ),
//           itemBuilder: (context, index) {
//             AffiliateTransactionRes? data = provider.dataClaim?[index];
//             return AffiliateTranItem(data: data);
//           },
//           separatorBuilder: (context, index) {
//             return SpacerVertical(height: 10);
//           },
//           itemCount: provider.dataClaim?.length ?? 0,
//         ),
//       ),
//     );
//   }
// }
