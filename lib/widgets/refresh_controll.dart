// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';

// class RefreshControl extends StatefulWidget {
//   const RefreshControl({
//     required this.onRefresh,
//     required this.onLoadMore,
//     required this.child,
//     this.canLoadMore = true,
//     super.key,
//   });
// //
//   final Future Function() onRefresh;
//   final Future Function() onLoadMore;
//   final Widget child;
//   final bool canLoadMore;

//   @override
//   State<RefreshControl> createState() => _RefreshControlState();
// }

// class _RefreshControlState extends State<RefreshControl> {
//   final RefreshController _refreshController = RefreshController(
//     initialRefresh: false,
//   );

//   @override
//   Widget build(BuildContext context) {
//     // Utils().showLog("******************** Can Load More =>  ${widget.canLoadMore} ");

//     return SmartRefresher(
//       enablePullUp: true,
//       footer: CustomFooter(
//         height: widget.canLoadMore ? 100 : 0,
//         builder: (BuildContext context, LoadStatus? mode) {
//           Widget body = const SizedBox();
//           // Utils().showLog("******************** $mode ");
//           if (mode == LoadStatus.idle) {
//             // body = const CircularProgressIndicator(
//             //   strokeWidth: 4,
//             //   color: ThemeColors.accent,
//             // );
//             // body = const SizedBox();
//           } else if (mode == LoadStatus.loading) {
//             body = const CircularProgressIndicator(
//               strokeWidth: 4,
//               color: ThemeColors.accent,
//             );
//           } else if (mode == LoadStatus.failed) {
//             body = const SizedBox();
//           } else if (mode == LoadStatus.canLoading) {
//             body = const CircularProgressIndicator(
//               strokeWidth: 4,
//               color: ThemeColors.accent,
//             );
//           } else {
//             body = const SizedBox();
//           }
//           return Visibility(
//             visible: widget.canLoadMore == true ? true : false,
//             child: SizedBox(child: Center(child: body)),
//           );
//         },
//       ),
//       controller: _refreshController,
//       onRefresh: () async {
//         final player = AudioPlayer();
//         player.play(AssetSource(AudioFiles.refresh), volume: 0.18);
//         await widget.onRefresh();
//         _refreshController.refreshCompleted();
//       },
//       onLoading: () async {
//         if (widget.canLoadMore) {
//           await widget.onLoadMore();
//         }
//         _refreshController.loadComplete();
//       },
//       child: widget.child,
//     );
//   }
// }
