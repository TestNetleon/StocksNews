// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';

// import '../../route/my_app.dart';
// import '../../utils/utils.dart';

// class InAppPurchaseUI extends StatefulWidget {
//   const InAppPurchaseUI({super.key});

//   @override
//   State<InAppPurchaseUI> createState() => _InAppPurchaseUIState();
// }

// class _InAppPurchaseUIState extends State<InAppPurchaseUI> {
//   PurchasesConfiguration? configuration;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ThemeButton(
//           text: "Configure",
//           onPressed: () {
//             initPlatformState();
//           },
//         ),
//         // ThemeButton(
//         //   text: "Click",
//         //   onPressed: () {},
//         // ),
//       ],
//     );
//   }

//   Future<void> initPlatformState() async {
//     Purchases.setLogLevel(LogLevel.debug);

//     if (Platform.isAndroid) {
//       configuration =
//           PurchasesConfiguration("goog_frHKXAaNeqxuVOxSDomgxquiJhy");
//     } else if (Platform.isIOS) {
//       configuration =
//           PurchasesConfiguration("appl_kHwXNrngqMNktkEZJqYhEgLjbcC");
//     }

//     if (configuration != null) {
//       await Purchases.configure(configuration!);

//       PaywallResult result = await RevenueCatUI.presentPaywall();
//       Utils().showLog("$result");
//       await _result(result);
//     }
//   }

//   Future _result(PaywallResult result) async {
//     switch (result) {
//       case PaywallResult.cancelled:
//         break;
//       case PaywallResult.error:
//         popUpAlert(
//           message: Const.errSomethingWrong,
//           title: "Alert",
//           icon: Images.alertPopGIF,
//         );
//         break;
//       case PaywallResult.notPresented:
//         popUpAlert(
//           message: "Paywall Not Presented",
//           title: "Alert",
//           icon: Images.alertPopGIF,
//         );
//         break;

//       case PaywallResult.purchased:
//         await _purchaseSuccess();
//         break;

//       case PaywallResult.restored:
//         break;

//       default:
//     }
//   }
// }

// _purchaseSuccess() async {
//   await showModalBottomSheet(
//     useSafeArea: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(5),
//         topRight: Radius.circular(5),
//       ),
//     ),
//     backgroundColor: ThemeColors.transparent,
//     isScrollControlled: true,
//     context: navigatorKey.currentContext!,
//     builder: (context) {
//       return const SubscriptionPurchased();
//     },
//   );
// }

// class SubscriptionPurchased extends StatelessWidget {
//   const SubscriptionPurchased({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [ThemeColors.bottomsheetGradient, Colors.black],
//         ),
//         color: ThemeColors.background,
//         border: Border(
//           top: BorderSide(color: ThemeColors.greyBorder),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 6.sp,
//               width: 50.sp,
//               margin: EdgeInsets.only(top: 8.sp),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.sp),
//                 color: ThemeColors.greyBorder,
//               ),
//             ),
//             Image.asset(
//               Images.referSuccess,
//               height: 250,
//               width: 300,
//             ),
//             Text(
//               "Payment successfully completed",
//               textAlign: TextAlign.center,
//               style: styleBaseBold(fontSize: 35),
//             ),
//             const SpacerVertical(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 "Congratulations, Explore Stocks.News without limits.",
//                 textAlign: TextAlign.center,
//                 style: styleBaseRegular(
//                     fontSize: 20, color: ThemeColors.greyText),
//               ),
//             ),
//             const SpacerVertical(height: 70),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: ThemeButton(
//                 text: "GO TO HOME",
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
