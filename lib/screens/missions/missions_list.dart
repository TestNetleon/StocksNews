// import 'package:flutter/material.dart';
// import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

// import 'package:stocks_news_new/screens/missions/missions_item.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../utils/constants.dart';

// class MissionsList extends StatefulWidget {
//   const MissionsList({super.key});

//   @override
//   State<MissionsList> createState() => _MissionsListState();
// }

// class _MissionsListState extends State<MissionsList> {
//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   DividendsProvider provider = context.read<DividendsProvider>();
//     //   if (provider.data != null) {
//     //     return;
//     //   }
//     //   provider.getDividendsStocks();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//           left: Dimen.padding, right: Dimen.padding, bottom: 40),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: ThemeColors.background,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(Dimen.padding),
//                   child: Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Reach next level",
//                             style: stylePTSansBold(),
//                           ),
//                           const SpacerVertical(height: 5),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(
//                                 width: 100,
//                                 height: 5,
//                                 child: FAProgressBar(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(5)),
//                                   currentValue: 70,
//                                   displayTextStyle: styleGeorgiaBold(
//                                       color:
//                                           ThemeColors.progressbackgroundColor),
//                                   displayText: '',
//                                   animatedDuration:
//                                       const Duration(milliseconds: 500),
//                                   progressColor:
//                                       ThemeColors.progressbackgroundColor,
//                                   backgroundColor: ThemeColors.greyBorder,
//                                 ),
//                               ),
//                               const SpacerHorizontal(width: 10),
//                               Text(
//                                 "84",
//                                 style: stylePTSansRegular(fontSize: 12),
//                               ),
//                               Text(
//                                 " / 50",
//                                 style: stylePTSansRegular(fontSize: 12),
//                               ),
//                               const SpacerHorizontal(width: 10),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: ThemeColors.background,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color:
//                                           const Color.fromARGB(255, 37, 37, 37)
//                                               .withOpacity(0.5), // Shadow color
//                                       spreadRadius: 2,
//                                       blurRadius: 5,
//                                       offset: const Offset(0, 1),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 5, horizontal: 10),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Icon(
//                                         Icons.ads_click_sharp,
//                                         size: 14,
//                                         color: ThemeColors.accent,
//                                       ),
//                                       const SpacerHorizontal(width: 5),
//                                       Text(
//                                         "10",
//                                         style: stylePTSansRegular(fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SpacerHorizontal(width: 20),
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: ThemeColors.progressbackgroundColorDark,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 171, 171, 171)
//                                     .withOpacity(0.5), // Shadow color
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Text(
//                               textAlign: TextAlign.center,
//                               "Claim",
//                               style: stylePTSansBold(fontSize: 18),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           )

//           // Expanded(
//           //   child: BaseUiContainer(
//           //     error: provider.error,
//           //     hasData: data != null && data.isNotEmpty,
//           //     isLoading: provider.isLoading,
//           //     errorDispCommon: true,
//           //     showPreparingText: true,
//           //     onRefresh: () => provider.getDividendsStocks(),
//           //     child: RefreshControl(
//           //       onRefresh: () async => provider.getDividendsStocks(),
//           //       canLoadMore: provider.canLoadMore,
//           //       onLoadMore: () async =>
//           //           provider.getDividendsStocks(loadMore: true),
//           //       child: ListView.separated(
//           //         padding: const EdgeInsets.only(top: Dimen.padding),
//           //         itemBuilder: (context, index) {
//           //           if (data == null || data.isEmpty) {
//           //             return const SizedBox();
//           //           }
//           //           return DividendsItem(data: data[index], index: index);
//           //         },
//           //         separatorBuilder: (BuildContext context, int index) {
//           //           return const SpacerVertical(height: 12);
//           //         },
//           //         // itemCount: up?.length ?? 0,
//           //         itemCount: data?.length ?? 0,
//           //       ),
//           //     ),
//           //   ),
//           // ),|
//           ,
//           Expanded(
//             child: ListView.separated(
//               shrinkWrap: true,
//               padding: const EdgeInsets.only(top: Dimen.padding),
//               itemBuilder: (context, index) {
//                 // if (data == null || data.isEmpty) {
//                 //   return const SizedBox();
//                 // }
//                 return const MissionsItem();
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return const SpacerVertical(height: 12);
//               },
//               // itemCount: up?.length ?? 0,
//               itemCount: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
