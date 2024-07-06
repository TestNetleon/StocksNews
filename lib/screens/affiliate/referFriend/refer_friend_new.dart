// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/screens/affiliate/referFriend/widget/refer_header.dart';
// import 'package:stocks_news_new/screens/affiliate/referFriend/widget/refer_how_does_work.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';

// class ReferFriendNew extends StatelessWidget {
//   const ReferFriendNew({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       bottomSafeAreaColor: ThemeColors.background,
//       appBar: const AppBarHome(
//         isPopback: true,
//         canSearch: true,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 200),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const ReferHeader(),
//                   const SpacerVertical(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.all(Dimen.padding),
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: ThemeColors.background,
//                       ),
//                       padding: const EdgeInsets.all(Dimen.padding),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Limited Period Offer",
//                             style: stylePTSansBold(),
//                           ),
//                           const SpacerVertical(height: 10),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "You and your invited friend will get 10000 SHIB each on successful referral",
//                                   style: stylePTSansRegular(),
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.offline_pin_rounded,
//                                 size: 50,
//                               ),
//                             ],
//                           ),
//                           const SpacerVertical(height: 30),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: ThemeColors.blackShade,
//                             ),
//                             padding: const EdgeInsets.all(Dimen.padding),
//                             child: Text(
//                               "valid till 31 Aug 2024",
//                               style: stylePTSansRegular(),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   const ReferHowDoesWork()
//                 ],
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Divider(
//                   color: ThemeColors.greyBorder,
//                   height: 0.sp,
//                   thickness: 1,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   color: ThemeColors.background,
//                   child: Padding(
//                     padding: const EdgeInsets.all(Dimen.padding),
//                     child: Column(
//                       children: [
//                         ThemeButton(
//                           // text: "Share with friends",
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.share,
//                                 size: 18,
//                               ),
//                               const SpacerHorizontal(width: 6),
//                               Flexible(
//                                 child: Text(
//                                   "Share Invite",
//                                   style: stylePTSansBold(fontSize: 18),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           onPressed: () {
//                             // Share.share(
//                             //   "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
//                             // );
//                           },
//                         ),
//                         const SpacerVertical(height: 20),
//                         DottedBorder(
//                           color:
//                               ThemeColors.accent, // Color of the dashed border
//                           strokeWidth: 0, // Width of the dashed border
//                           dashPattern: const [6, 3],
//                           borderType: BorderType
//                               .RRect, // Type of border (rounded rectangle)
//                           radius: const Radius.circular(
//                               10), // Length and spacing of the dashes
//                           child: ThemeButton(
//                             color: Colors.transparent,
//                             // text: "Share with friends",
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.copy,
//                                   size: 18,
//                                 ),
//                                 const SpacerHorizontal(width: 6),
//                                 Flexible(
//                                   child: Text(
//                                     "T65ZF93V",
//                                     style: stylePTSansBold(fontSize: 18),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             onPressed: () {
//                               // Share.share(
//                               //   "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
//                               // );
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
