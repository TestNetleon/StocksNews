// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/news_detail.provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
// import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
// import 'package:stocks_news_new/screens/membership/store/store.dart';
// import 'package:stocks_news_new/screens/membership_new/membership.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/custom/confirmation_point_popup.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button_small.dart';
// import '../../../../../api/api_response.dart';
// import '../../../../../utils/utils.dart';
// import '../../../../../widgets/custom/warning_text.dart';
// import '../../../../auth/base/base_auth.dart';
// import '../../../../offerMembership/blackFriday/scanner.dart';
// import '../../../../offerMembership/christmas/scanner.dart';

// class NewsDetailsLock extends StatefulWidget {
//   final String? slug;

//   const NewsDetailsLock({super.key, this.slug});

//   @override
//   State<NewsDetailsLock> createState() => _NewsDetailsLockState();
// }

// class _NewsDetailsLockState extends State<NewsDetailsLock> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // _getInitialData();
//     });
//   }

//   void _onSubmit(value) async {
//     UserProvider userProvider = context.read<UserProvider>();
//     NewsDetailProvider provider = context.read<NewsDetailProvider>();
//     if (userProvider.user == null) {
//       // await loginSheet();
//       await loginFirstSheet();

//       if (context.read<UserProvider>().user != null) {
//         await provider.getNewsDetailData(
//           showProgress: false,
//           slug: widget.slug,
//         );
//       }
//       return;
//     }

//     provider.requestFeedbackSubmit(
//       showProgress: true,
//       feedbackType: "news",
//       id: provider.data!.postDetail!.id!,
//       type: value,
//     );
//   }

//   void _onLoginClick(context) async {
//     // await loginSheet();
//     await loginFirstSheet();

//     UserProvider userProvider =
//         Provider.of<UserProvider>(context, listen: false);
//     NewsDetailProvider provider =
//         Provider.of<NewsDetailProvider>(context, listen: false);

//     if (userProvider.user != null) {
//       provider.getNewsDetailData(slug: widget.slug);
//     }
//   }

//   Future _onReferClick(BuildContext context) async {
//     UserProvider userProvider = context.read<UserProvider>();

//     // if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
//     if (userProvider.user?.affiliateStatus != 1) {
//       await referLogin();
//     } else {
//       if (userProvider.user != null) {
//         await Share.share(
//           "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
//         );
//       }
//     }
//   }

//   Future _onViewNewsClick(context) async {
//     NewsDetailProvider provider =
//         Provider.of<NewsDetailProvider>(context, listen: false);

//     confirmationPopUp(
//       points: provider.data?.postDetail?.pointsRequired,
//       message: provider.data?.postDetail?.popUpMessage,
//       buttonText: provider.data?.postDetail?.popUpButton,
//       onTap: () async {
//         HomeProvider homeProvider =
//             Provider.of<HomeProvider>(context, listen: false);
//         await provider.getNewsDetailData(
//             slug: widget.slug, pointsDeducted: true);
//         homeProvider.getHomeSlider();
//       },
//     );
//   }

//   Future _membership() async {
//     UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
//     Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;
//     if (provider.user?.phone == null || provider.user?.phone == '') {
//       await membershipLogin();
//     }
//     if (provider.user?.phone != null && provider.user?.phone != '') {
//       // await RevenueCatService.initializeSubscription();
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (_) => const NewMembership(),
//       //   ),
//       // );
//       closeKeyboard();
//       if (extra?.showBlackFriday == true) {
//         await Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => const BlackFridayMembershipIndex(),
//           ),
//         );
//       } else if (extra?.christmasMembership == true ||
//           extra?.newYearMembership == true) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           createRoute(
//             const ChristmasMembershipIndex(),
//           ),
//         );
//       } else {
//         await Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => const NewMembership(),
//           ),
//         );
//       }
//     }
//   }

//   Future _navigateToStore() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const Store(),
//       ),
//     );
//   }

//   // Future _membership() async {
//   //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
//   //   await askToSubscribe(
//   //     onPressed: () async {
//   //       Navigator.pop(navigatorKey.currentContext!);
//   //       if (provider.user?.phone == null || provider.user?.phone == '') {
//   //         await membershipLogin();
//   //       }
//   //       if (provider.user?.phone != null && provider.user?.phone != '') {
//   //         await RevenueCatService.initializeSubscription();
//   //       }
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     NewsDetailProvider provider = context.watch<NewsDetailProvider>();
//     UserProvider userProvider = context.watch<UserProvider>();

//     bool isLogin = userProvider.user != null;
//     bool hasMembership = userProvider.user?.membership?.purchased == 1;
//     bool havePoints = provider.data?.postDetail?.totalPoints != null &&
//         (provider.data?.postDetail?.totalPoints > 0);

//     bool haveEnoughPoints = (provider.data?.postDetail?.totalPoints == null ||
//             provider.data?.postDetail?.pointsRequired == null)
//         ? false
//         : (provider.data?.postDetail?.totalPoints! >=
//             provider.data?.postDetail?.pointsRequired!);

//     bool showLoginButton = !isLogin;
//     bool showViewReport = isLogin && havePoints && haveEnoughPoints;
//     bool showRefer = isLogin && (!havePoints || !haveEnoughPoints);
//     bool showSubscribe = isLogin &&
//         !hasMembership &&
//         showMembership &&
//         (!havePoints || !haveEnoughPoints);
//     bool showStore = isLogin &&
//         hasMembership &&
//         showMembership &&
//         (!havePoints || !haveEnoughPoints);

//     double height = (ScreenUtil().screenHeight -
//             ScreenUtil().bottomBarHeight -
//             ScreenUtil().statusBarHeight) /
//         2.2;

//     if ((provider.data?.postDetail?.readingStatus == false) &&
//         !provider.isLoading) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: Container(
//               height: height / 2,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     ThemeColors.tabBack,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             // height: height / 1.1,
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//               color: ThemeColors.tabBack,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 10,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.lock, size: 40),
//                   const SpacerVertical(),
//                   Text(
//                     "${provider.data?.postDetail?.readingTitle}",
//                     style: stylePTSansBold(fontSize: 18),
//                   ),
//                   const SpacerVertical(height: 10),
//                   Text(
//                     "${provider.data?.postDetail?.readingSubtitle}",
//                     style: stylePTSansRegular(
//                       fontSize: 14,
//                       height: 1.3,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SpacerVertical(height: 10),
//                   if (showLoginButton)
//                     ThemeButtonSmall(
//                       onPressed: () {
//                         _onLoginClick(context);
//                       },
//                       mainAxisSize: MainAxisSize.max,
//                       text: "Register/Login to Continue",
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5,
//                         vertical: 11,
//                       ),
//                       textSize: 15,
//                       fontBold: true,
//                       iconFront: true,
//                       icon: Icons.lock,
//                       radius: 30,
//                       margin: const EdgeInsets.only(bottom: 10),
//                     ),
//                   if (showViewReport)
//                     ThemeButtonSmall(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5,
//                         vertical: 11,
//                       ),
//                       textSize: 15,
//                       iconFront: true,
//                       fontBold: true,
//                       radius: 30,
//                       icon: Icons.visibility,
//                       mainAxisSize: MainAxisSize.max,
//                       onPressed: () => _onViewNewsClick(context),
//                       text: "View News",
//                       margin: const EdgeInsets.only(bottom: 10),
//                     ),
//                   if (showRefer)
//                     ThemeButtonSmall(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5,
//                         vertical: 11,
//                       ),
//                       textSize: 15,
//                       fontBold: true,
//                       iconWidget: Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Image.asset(
//                           Images.referAndEarn,
//                           height: 18,
//                           width: 18,
//                           color: ThemeColors.white,
//                         ),
//                       ),
//                       iconFront: true,
//                       icon: Icons.earbuds_rounded,
//                       mainAxisSize: MainAxisSize.max,
//                       radius: 30,
//                       onPressed: () async {
//                         await _onReferClick(context);
//                       },
//                       text: "Refer and Earn",
//                       margin: const EdgeInsets.only(bottom: 10),
//                     ),
//                   if (showSubscribe)
//                     ThemeButtonSmall(
//                       color: const Color.fromARGB(
//                         255,
//                         194,
//                         216,
//                         51,
//                       ),
//                       textColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5,
//                         vertical: 11,
//                       ),
//                       textSize: 15,
//                       fontBold: true,
//                       iconFront: true,
//                       radius: 30,
//                       icon: Icons.card_membership,
//                       textAlign: TextAlign.start,
//                       iconWidget: Padding(
//                         padding: const EdgeInsets.only(
//                           right: 10,
//                         ),
//                         child: Image.asset(
//                           Images.membership,
//                           height: 18,
//                           width: 18,
//                           color: Colors.black,
//                         ),
//                       ),
//                       mainAxisSize: MainAxisSize.max,
//                       onPressed: () async {
//                         await _membership();
//                       },
//                       text: "Become a Premium Member",
//                       showArrow: false,
//                       margin: const EdgeInsets.only(bottom: 10),
//                     ),
//                   if (showStore)
//                     ThemeButtonSmall(
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       textColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5,
//                         vertical: 7,
//                       ),
//                       textSize: 15,
//                       fontBold: true,
//                       iconFront: true,
//                       radius: 30,
//                       icon: Icons.card_membership,
//                       textAlign: TextAlign.start,
//                       iconWidget: Padding(
//                         padding: const EdgeInsets.only(
//                           right: 10,
//                         ),
//                         child: Image.asset(
//                           Images.pointIcon3,
//                           height: 28,
//                           width: 28,
//                           // color: Colors.black,
//                         ),
//                       ),
//                       mainAxisSize: MainAxisSize.max,
//                       onPressed: _navigateToStore,
//                       text: "Buy Points",
//                       showArrow: false,
//                       margin: const EdgeInsets.only(bottom: 10),
//                     ),
//                   WarningTextOnLock(
//                     warningText: provider.data?.postDetail?.warningText,
//                   ),
//                   // SpacerVertical(height: ScreenUtil().scaleWidth + 200),
//                 ],
//               ),
//             ),

//             // child: context.watch<UserProvider>().user == null
//             //     ? Padding(
//             //         padding: const EdgeInsets.symmetric(
//             //           horizontal: 20,
//             //           vertical: 10,
//             //         ),
//             //         child: Column(
//             //           mainAxisAlignment: MainAxisAlignment.center,
//             //           children: [
//             //             const Icon(
//             //               Icons.lock,
//             //               size: 40,
//             //               color: ThemeColors.themeGreen,
//             //             ),
//             //             const SpacerVertical(height: 15),
//             //             Text(
//             //               "${provider.data?.postDetail?.readingTitle}",
//             //               style: stylePTSansBold(fontSize: 18),
//             //             ),
//             //             const SpacerVertical(height: 10),
//             //             Text(
//             //               "${provider.data?.postDetail?.readingSubtitle}",
//             //               style: stylePTSansRegular(
//             //                 fontSize: 14,
//             //                 height: 1.3,
//             //               ),
//             //               textAlign: TextAlign.center,
//             //             ),
//             //             const SpacerVertical(height: 10),
//             //             ThemeButtonSmall(
//             //               onPressed: () {
//             //                 _onLoginClick(context);
//             //               },
//             //               mainAxisSize: MainAxisSize.max,
//             //               text: "Register/Login to Continue",
//             //               padding: const EdgeInsets.symmetric(
//             //                 horizontal: 5,
//             //                 vertical: 11,
//             //               ),
//             //               textSize: 15,
//             //               fontBold: true,
//             //               iconFront: true,
//             //               icon: Icons.lock,
//             //               radius: 30,
//             //             ),
//             //             const SpacerVertical(),
//             //           ],
//             //         ),
//             //       )
//             //     : provider.data?.postDetail?.balanceStatus == null ||
//             //             provider.data?.postDetail?.balanceStatus == false
//             //         ? Padding(
//             //             padding: const EdgeInsets.symmetric(
//             //               horizontal: 20,
//             //               vertical: 10,
//             //             ),
//             //             child: Column(
//             //               mainAxisAlignment: MainAxisAlignment.center,
//             //               children: [
//             //                 const Icon(Icons.lock, size: 40),
//             //                 const SpacerVertical(),
//             //                 Text(
//             //                   "${provider.data?.postDetail?.readingTitle}",
//             //                   style: stylePTSansBold(fontSize: 18),
//             //                 ),
//             //                 const SpacerVertical(height: 10),
//             //                 Text(
//             //                   "${provider.data?.postDetail?.readingSubtitle}",
//             //                   style: stylePTSansRegular(
//             //                     fontSize: 14,
//             //                     height: 1.3,
//             //                   ),
//             //                   textAlign: TextAlign.center,
//             //                 ),
//             //                 const SpacerVertical(height: 10),
//             //                 ThemeButtonSmall(
//             //                   padding: const EdgeInsets.symmetric(
//             //                     horizontal: 5,
//             //                     vertical: 11,
//             //                   ),
//             //                   textSize: 15,
//             //                   fontBold: true,
//             //                   iconWidget: Padding(
//             //                     padding: const EdgeInsets.only(right: 10),
//             //                     child: Image.asset(
//             //                       Images.referAndEarn,
//             //                       height: 18,
//             //                       width: 18,
//             //                       color: ThemeColors.white,
//             //                     ),
//             //                   ),
//             //                   iconFront: true,
//             //                   icon: Icons.earbuds_rounded,
//             //                   mainAxisSize: MainAxisSize.max,
//             //                   radius: 30,
//             //                   onPressed: () async {
//             //                     await _onReferClick(context);
//             //                   },
//             //                   text: "Refer and Earn",
//             //                 ),
//             //                 const SpacerVertical(height: 10),
//             //                 Visibility(
//             //                   visible: showMembership,
//             //                   child: ThemeButtonSmall(
//             //                     color: const Color.fromARGB(
//             //                       255,
//             //                       194,
//             //                       216,
//             //                       51,
//             //                     ),
//             //                     textColor: Colors.black,
//             //                     padding: const EdgeInsets.symmetric(
//             //                       horizontal: 5,
//             //                       vertical: 11,
//             //                     ),
//             //                     textSize: 15,
//             //                     fontBold: true,
//             //                     iconFront: true,
//             //                     radius: 30,
//             //                     icon: Icons.card_membership,
//             //                     textAlign: TextAlign.start,
//             //                     iconWidget: Padding(
//             //                       padding: const EdgeInsets.only(
//             //                         right: 10,
//             //                       ),
//             //                       child: Image.asset(
//             //                         Images.membership,
//             //                         height: 18,
//             //                         width: 18,
//             //                         color: ThemeColors.white,
//             //                       ),
//             //                     ),
//             //                     mainAxisSize: MainAxisSize.max,
//             //                     onPressed: () async {
//             //                       await _membership();
//             //                     },
//             //                     text: "Upgrade Membership for more points",
//             //                     showArrow: false,
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //           )
//             //         : Padding(
//             //             padding: const EdgeInsets.symmetric(
//             //               horizontal: 20,
//             //               vertical: 10,
//             //             ),
//             //             child: Column(
//             //               mainAxisAlignment: MainAxisAlignment.center,
//             //               children: [
//             //                 const Icon(Icons.lock, size: 40),
//             //                 const SpacerVertical(),
//             //                 Text(
//             //                   "${provider.data?.postDetail?.readingTitle}",
//             //                   style: stylePTSansBold(fontSize: 18),
//             //                 ),
//             //                 const SpacerVertical(height: 10),
//             //                 Text(
//             //                   "${provider.data?.postDetail?.readingSubtitle}",
//             //                   style: stylePTSansRegular(
//             //                     fontSize: 14,
//             //                     height: 1.3,
//             //                   ),
//             //                   textAlign: TextAlign.center,
//             //                 ),
//             //                 const SpacerVertical(height: 10),
//             //                 ThemeButtonSmall(
//             //                   padding: const EdgeInsets.symmetric(
//             //                     horizontal: 5,
//             //                     vertical: 11,
//             //                   ),
//             //                   textSize: 15,
//             //                   iconFront: true,
//             //                   fontBold: true,
//             //                   radius: 30,
//             //                   icon: Icons.visibility,
//             //                   mainAxisSize: MainAxisSize.max,
//             //                   onPressed: () => _onViewNewsClick(context),
//             //                   text: "View News",
//             //                 ),
//             //               ],
//             //             ),
//             //           ),
//           ),
//         ],
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
// }
