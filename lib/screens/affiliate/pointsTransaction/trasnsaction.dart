// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/leaderboard.dart';
// import 'package:stocks_news_new/screens/affiliate/claimHistory/index.dart';
// import 'package:stocks_news_new/screens/affiliate/referFriend/widget/points_summary.dart';
// import 'package:stocks_news_new/screens/claimPoints/index.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/helpdesk_error.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';

// import '../../../modals/affiliate/transaction.dart';
// import '../../../routes/my_app.dart';
// import '../../../ui/tabs/tabs.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/utils.dart';
// import '../../blogDetail/index.dart';
// import '../../helpDesk/chats/index.dart';
// import '../../stockDetail/index.dart';

// class AffiliateTransaction extends StatefulWidget {
//   const AffiliateTransaction({super.key, this.fromDrawer = false});
//   final bool fromDrawer;

//   @override
//   State<AffiliateTransaction> createState() => _AffiliateTransactionState();
// }

// class _AffiliateTransactionState extends State<AffiliateTransaction> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<LeaderBoardProvider>().getReferData();
//       context.read<LeaderBoardProvider>().getTransactionData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
//     HomeProvider homeProvider = context.watch<HomeProvider>();

//     return BaseContainer(
//       appBar: AppBarHome(
//         isPopBack: true,
//         title: provider.extraNew?.title.toString() ?? "",
//       ),
//       body: CommonEmptyError(
//         hasData: provider.tnxData == null || provider.tnxData?.isEmpty == true,
//         isLoading: provider.isLoadingT,
//         title: "Points Transactions",
//         subTitle: provider.errorT,
//         onClick: () async {
//           provider.getTransactionData();
//         },
//         child: Column(
//           children: [
//             Expanded(
//               child: BaseUiContainer(
//                 hasData: !provider.isLoadingT &&
//                     (provider.tnxData?.isNotEmpty == true &&
//                         provider.tnxData != null),
//                 isLoading: provider.isLoadingT,
//                 error: provider.errorT,
//                 onRefresh: () async {
//                   provider.getTransactionData();
//                 },
//                 showPreparingText: true,
//                 child: CommonRefreshIndicator(
//                   onRefresh: () async {
//                     context.read<LeaderBoardProvider>().getReferData();
//                     provider.getTransactionData();
//                   },
//                   child: ListView.separated(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 0,
//                     ),
//                     itemBuilder: (context, index) {
//                       if (index == 0) {
//                         return Column(
//                           children: [
//                             ScreenTitle(
//                               // title: provider.extraNew?.title.toString() ?? "",
//                               subTitle:
//                                   provider.extraNew?.subTitle.toString() ?? "",
//                               dividerPadding: EdgeInsets.only(bottom: 5),
//                             ),
//                             const PointsSummary(fromDrawer: true),
//                             const SpacerVertical(height: 10),
//                             AffiliateTranItem(data: provider.tnxData?[index]),
//                           ],
//                         );
//                       }
//                       return AffiliateTranItem(
//                         data: provider.tnxData?[index],
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return const SpacerVertical(height: 10);
//                     },
//                     itemCount: provider.tnxData?.length ?? 0,
//                   ),
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: homeProvider.extra?.showRewards == true,
//               child: ThemeButton(
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ClaimPointsIndex(),
//                     ),
//                   );
//                   if (result == true) {
//                     provider.getReferData();
//                     provider.getTransactionData();
//                   }
//                 },
//                 text: "Claim Your Rewards",
//                 margin: EdgeInsets.only(top: 5, bottom: 10),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AffiliateTranItem extends StatelessWidget {
//   final AffiliateTransactionRes? data;
//   const AffiliateTranItem({super.key, this.data});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         if (data?.id != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ClaimHistoryIndex(
//                 type: "${data?.txnType}",
//                 appbarHeading: "${data?.label}",
//                 id: data?.id,
//               ),
//             ),
//           );
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         decoration: BoxDecoration(
//           border: Border.all(
//             // color: ThemeColors.greyBorder.withOpacity(0.4),
//             color: data?.spent != null && data?.spent != 0
//                 ? ThemeColors.sos.withOpacity(0.4)
//                 : ThemeColors.accent.withOpacity(0.4),
//           ),
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 23, 23, 23),
//               Color.fromARGB(255, 39, 39, 39),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 0.0),
//                         child: Image.network(data?.icon ?? "",
//                             height: 30, color: Colors.green),
//                       ),
//                       const SpacerHorizontal(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data?.label ?? "",
//                               style: styleBaseBold(fontSize: 16),
//                             ),
//                             RichText(
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: data?.txnDetail ?? "",
//                                     style: styleBaseRegular(height: 1.5),
//                                   ),
//                                   TextSpan(
//                                     text: " ${data?.title ?? ""}",
//                                     style: styleBaseRegular(
//                                       height: 1.5,
//                                       color: data?.txnType != "" &&
//                                               data?.slug != ""
//                                           ? ThemeColors.accent
//                                           : ThemeColors.white,
//                                       // data?.spent != null && data?.spent != 0
//                                       //     ? ThemeColors.accent
//                                       //     : ThemeColors.white,
//                                     ),
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = data?.spent != null &&
//                                               data?.spent != 0
//                                           ? () {
//                                               _onTap(context);
//                                             }
//                                           : null,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               data?.createdAt ?? "",
//                               style: styleBaseRegular(
//                                   color: ThemeColors.greyText, fontSize: 13),
//                             ),
//                             const SpacerVertical(
//                               height: 10.0,
//                             ),
//                             Text(
//                               (data?.spent != null && (data?.spent ?? 0) > 0)
//                                   ? "-${data?.spent}"
//                                   : (data?.earn != null &&
//                                           (data?.earn ?? 0) > 0)
//                                       ? "+${data?.earn}"
//                                       : "",
//                               style: styleBaseBold(
//                                   fontSize: 20,
//                                   color: data?.earn != null
//                                       ? Colors.green
//                                       : Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             // const Divider(
//             //   color: ThemeColors.greyBorder,
//             //   height: 20,
//             // ),
//             // Text(
//             //   "${data?.txnDetail ?? ""} - ${data?.title}",
//             //   style: styleBaseRegular(height: 1.5),
//             // ),

//             // const SpacerVertical(height: 10),
//             // Visibility(
//             //   visible: data?.duration != null && data?.duration != "",
//             //   child: Container(
//             //     margin: const EdgeInsets.only(top: 3),
//             //     child: Text(
//             //       data?.duration ?? "",
//             //       style: styleBaseRegular(height: 1.5),
//             //     ),
//             //   ),
//             // ),
//             // const SpacerVertical(height: 10),
//             // Align(
//             //   alignment: Alignment.centerRight,
//             //   child: Text(
//             //     data?.createdAt ?? "",
//             //     style:
//             //         styleBaseRegular(color: ThemeColors.greyText, fontSize: 13),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onTap(
//     BuildContext context,
//   ) async {
//     try {
//       String? type = data?.txnType;
//       String? slug = data?.slug;
//       if (type == NotificationType.dashboard.name) {
//         Navigator.popUntil(
//             navigatorKey.currentContext!, (route) => route.isFirst);
//         Navigator.pushReplacement(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(builder: (_) => const Tabs()),
//         );
//       } else if (slug != '' && type == NotificationType.ticketDetail.name) {
//         Navigator.pushReplacement(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             // builder: (_) => ChatScreen(
//             //   slug: "1",
//             //   ticketId: slug,
//             // ),
//             builder: (_) => HelpDeskAllChatsNew(
//               ticketId: slug ?? "N/A",
//             ),
//           ),
//         );
//       } else if (slug != '' && type == NotificationType.newsDetail.name) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(builder: (_) => NewsDetails(slug: slug)),
//         );
//       } else if (slug != '' && type == NotificationType.blogDetail.name) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => BlogDetail(
//               slug: slug ?? "",
//             ),
//           ),
//         );
//       } else if (slug != '' && type == NotificationType.stockDetail.name ||
//           isValidTickerSymbol(type ?? "")) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(builder: (_) => StockDetail(symbol: slug!)),
//         );
//       }
//     } catch (e) {
//       Utils().showLog("Exception ===>> $e");
//       Navigator.popUntil(
//           navigatorKey.currentContext!, (route) => route.isFirst);
//       Navigator.pushReplacement(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(builder: (_) => const Tabs()),
//       );
//     }
//   }
// }
