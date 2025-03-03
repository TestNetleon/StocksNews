// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/screens/membership_new/membership.dart';
// import '../../../api/api_response.dart';
// import '../../../providers/home_provider.dart';
// import '../../../providers/user_provider.dart';
// import '../../../routes/my_app.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/theme.dart';
// import '../../../utils/utils.dart';
// import '../../../widgets/spacer_vertical.dart';
// import '../../../widgets/theme_button_small.dart';
// import '../../auth/base/base_auth.dart';
// import '../../auth/membershipAsk/ask.dart';
// import '../../offerMembership/blackFriday/scanner.dart';
// import '../../offerMembership/christmas/scanner.dart';
// import '../../tabs/tabs.dart';

// class CommonLock extends StatelessWidget {
//   final bool showLogin;
//   final bool isLocked;
//   const CommonLock({
//     super.key,
//     this.showLogin = false,
//     this.isLocked = false,
//   });

//   void onBecomeMemberClick(BuildContext context) async {
//     UserProvider provider = context.read<UserProvider>();
//     if (provider.user == null) {
//       Utils().showLog("is Locked? $isLocked");

//       // Ask for LOGIN
//       // Navigator.pop(context);
//       // isPhone ? await loginSheet() : await loginSheetTablet();

//       await loginFirstSheet();

//       if (provider.user == null) {
//         return;
//       }
//     } else {
//       if (isLocked) {
//         if (provider.user?.phone == null || provider.user?.phone == '') {
//           await membershipLogin();
//         }
//         if (provider.user?.phone != null && provider.user?.phone != '') {
//           // await RevenueCatService.initializeSubscription();
//           // await Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (_) => const NewMembership()),
//           // );

//           closeKeyboard();
//           Extra? extra =
//               navigatorKey.currentContext!.read<HomeProvider>().extra;

//           if (extra?.showBlackFriday == true) {
//             await Navigator.push(
//               navigatorKey.currentContext!,
//               MaterialPageRoute(
//                 builder: (context) => const BlackFridayMembershipIndex(),
//               ),
//             );
//           } else if (extra?.christmasMembership == true ||
//               extra?.newYearMembership == true) {
//             Navigator.push(
//               navigatorKey.currentContext!,
//               createRoute(
//                 const ChristmasMembershipIndex(),
//               ),
//             );
//           } else {
//             await Navigator.push(
//               navigatorKey.currentContext!,
//               MaterialPageRoute(
//                 builder: (context) => const NewMembership(),
//               ),
//             );
//           }
//         }
//       }
//     }

//     // askToSubscribe(
//     //   onPressed: provider.user == null
//     //       ? () async {
//     //           Utils().showLog("is Locked? $isLocked");
//     //           //Ask for LOGIN
//     //           Navigator.pop(context);
//     //           isPhone ? await loginSheet() : await loginSheetTablet();
//     //           if (provider.user == null) {
//     //             return;
//     //           }
//     //           if (isLocked) {
//     //             if (provider.user?.phone == null ||
//     //                 provider.user?.phone == '') {
//     //               // await referLogin();
//     //               await membershipLogin();
//     //             }
//     //             if (provider.user?.phone != null &&
//     //                 provider.user?.phone != '') {
//     //               await RevenueCatService.initializeSubscription();
//     //             }
//     //           }
//     //         }
//     //       : () async {
//     //           Navigator.pop(context);
//     //           if (isLocked) {
//     //             if (provider.user?.phone == null ||
//     //                 provider.user?.phone == '') {
//     //               await membershipLogin();
//     //             }
//     //             if (provider.user?.phone != null &&
//     //                 provider.user?.phone != '') {
//     //               await RevenueCatService.initializeSubscription();
//     //             }
//     //           }
//     //         }
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = (ScreenUtil().screenHeight -
//             ScreenUtil().bottomBarHeight -
//             ScreenUtil().statusBarHeight) /
//         1.3;
//     UserProvider provider = context.watch<UserProvider>();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Expanded(
//           child: Container(
//             height: height / 2,
//             // height: double.infinity,
//             // width: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent,
//                   ThemeColors.tabBack,
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Container(
//           height: height / 1.2,
//           // width: double.infinity,
//           alignment: Alignment.center,
//           decoration: const BoxDecoration(
//             color: ThemeColors.tabBack,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 10,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // TODO: -------
//                 const Icon(
//                   Icons.lock,
//                   size: 40,
//                   color: ThemeColors.themeGreen,
//                 ),
//                 const SpacerVertical(height: 15),
//                 // TODO: -------

//                 // Image.asset(
//                 //   Images.lockGIF,
//                 //   height: 70,
//                 //   width: 70,
//                 // ),
//                 // const SpacerVertical(height: 5),
//                 Text(
//                   "Premium Content",
//                   style: stylePTSansBold(fontSize: 25),
//                 ),
//                 const SpacerVertical(height: 10),
//                 Text(
//                   "This content is only available for premium members. Please become a paid member to access.",
//                   style: stylePTSansRegular(
//                     fontSize: 15,
//                     height: 1.3,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SpacerVertical(height: 10),
//                 Visibility(
//                   visible: showMembership,
//                   child: ThemeButtonSmall(
//                     onPressed: () {
//                       onBecomeMemberClick(context);
//                     },
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
//                     textSize: 15,
//                     fontBold: true,
//                     iconFront: true,
//                     icon: Icons.lock,
//                     radius: 30,
//                     mainAxisSize: MainAxisSize.max,
//                     text: "Become a Premium Member",
//                     // showArrow: false,
//                   ),
//                 ),
//                 const SpacerVertical(height: 20),
//                 Visibility(
//                   visible: provider.user == null,
//                   child: GestureDetector(
//                     onTap: () async {
//                       // isPhone ? await loginSheet() : await loginSheetTablet();
//                       await loginFirstSheet();
//                       if (provider.user == null) {
//                         return;
//                       }
//                       Navigator.popUntil(navigatorKey.currentContext!,
//                           (route) => route.isFirst);
//                       Navigator.pushReplacement(
//                         navigatorKey.currentContext!,
//                         MaterialPageRoute(
//                           builder: (_) => const Tabs(index: 0),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Already have an account? Log in",
//                       style: stylePTSansRegular(
//                         fontSize: 16,
//                         height: 1.3,
//                         color: ThemeColors.themeGreen,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 // SpacerVertical(height: ScreenUtil().scaleWidth + 100),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
