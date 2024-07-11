// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/alerts/alerts.dart';
// import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
// import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
// import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
// import 'package:stocks_news_new/service/ask_subscription.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:vibration/vibration.dart';
// import '../../../../service/revenue_cat.dart';
// import '../../../../utils/dialogs.dart';
// import '../../../auth/membershipAsk/ask.dart';
// import 'alert_popup.dart';
// import 'button.dart';

// //
// class AddToAlertWatchlist extends StatelessWidget {
//   const AddToAlertWatchlist({super.key});

//   void _vibrate() async {
//     if (Platform.isAndroid) {
//       bool isVibe = await Vibration.hasVibrator() ?? false;
//       if (isVibe) {
//         // Vibration.vibrate(pattern: [0, 500], intensities: [255, 255]);
//         Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
//       } else {
//         Utils().showLog("$isVibe");
//       }
//     } else {
//       HapticFeedback.lightImpact();
//     }
//   }

//   Future _subscribe() async {
//     UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

//     if (provider.user?.phone == null || provider.user?.phone == '') {
//       await membershipLogin();
//     }
//     if (provider.user?.phone != null && provider.user?.phone != '') {
//       await RevenueCatService.initializeSubscription();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? symbol =
//         context.watch<StockDetailProviderNew>().tabRes?.keyStats?.symbol ?? "";
//     num alertOn =
//         context.watch<StockDetailProviderNew>().tabRes?.isAlertAdded ?? 0;
//     num watchlistOn =
//         context.watch<StockDetailProviderNew>().tabRes?.isWatchListAdded ?? 0;
//     UserProvider userProvider = context.watch<UserProvider>();
//     // HomeProvider homeProvider = context.watch<HomeProvider>();

//     bool purchased = userProvider.user?.membership?.purchased == 1;

//     bool isPresentAlert = userProvider.user?.membership?.permissions
//             ?.any((element) => element == "add-alert") ??
//         false;

//     // bool isPresentAlertE =
//     //     subscription?.permissions?.any((element) => element == "add-alert") ??
//     //         false;

//     bool isPresentWatchlist = userProvider.user?.membership?.permissions
//             ?.any((element) => element == "add-watchlist") ??
//         false;

//     // bool isPresentWatchlistE = subscription?.permissions
//     //         ?.any((element) => element == "add-watchlist") ??
//     //     false;

//     log("$purchased, $isPresentAlert");
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.sp),
//       child: Row(
//         children: [
//           AlertWatchlistButton(
//             backgroundColor:
//                 alertOn == 0 ? ThemeColors.accent : ThemeColors.background,
//             iconData: Icons.add_alert_outlined,
//             name: alertOn == 0 ? "Add to Alerts" : "Alert Added",

//             onTap: showMembership
//                 ? () {
//                     //Condition - User present and membership purchased

//                     if (userProvider.user != null &&
//                         (purchased && isPresentAlert)) {
//                       _vibrate();
//                       alertOn == 0
//                           ? _showAlertPopup(
//                               navigatorKey.currentContext!, symbol)
//                           : Navigator.push(
//                               navigatorKey.currentContext!,
//                               MaterialPageRoute(builder: (_) => const Alerts()),
//                             );
//                       return;
//                     }
//                     askToSubscribe(
//                       onPressed: userProvider.user == null
//                           ? () async {
//                               //Ask for LOGIN
//                               Navigator.pop(context);
//                               isPhone
//                                   ? await loginSheet()
//                                   : await loginSheetTablet();
//                               if (context.read<UserProvider>().user == null) {
//                                 return;
//                               }
//                               ApiResponse res = await context
//                                   .read<StockDetailProviderNew>()
//                                   .getTabData(symbol: symbol);
//                               try {
//                                 if (res.status) {
//                                   num alrtOn = navigatorKey.currentContext!
//                                           .read<StockDetailProviderNew>()
//                                           .tabRes
//                                           ?.isAlertAdded ??
//                                       0;
//                                   if (alrtOn == 0) {
//                                     await Future.delayed(
//                                         const Duration(milliseconds: 200));

//                                     //Check if its not purchased and not having access
//                                     if ((!purchased && !isPresentAlert)) {
//                                       await _subscribe();
//                                     }
//                                     if ((purchased && isPresentAlert)) {
//                                       await _showAlertPopup(
//                                           navigatorKey.currentContext!, symbol);
//                                     }
//                                   } else {
//                                     Navigator.push(
//                                       navigatorKey.currentContext!,
//                                       MaterialPageRoute(
//                                           builder: (_) => const Alerts()),
//                                     );
//                                   }
//                                 }
//                               } catch (e) {
//                                 Utils().showLog("----$e-----");
//                               }
//                             }
//                           : alertOn == 0
//                               ? () async {
//                                   Navigator.pop(context);

//                                   _vibrate();
//                                   if ((!purchased && !isPresentAlert)) {
//                                     await _subscribe();
//                                   }
//                                   if ((purchased && isPresentAlert)) {
//                                     await _showAlertPopup(
//                                         navigatorKey.currentContext!, symbol);
//                                   }
//                                 }
//                               : () async {
//                                   Navigator.pop(context);
//                                   _vibrate();
//                                   if ((!purchased && !isPresentAlert)) {
//                                     await _subscribe();
//                                   }
//                                   if ((purchased && isPresentAlert)) {
//                                     // await _showAlertPopup(
//                                     //     navigatorKey.currentContext!, symbol);

//                                     Navigator.push(
//                                       navigatorKey.currentContext!,
//                                       MaterialPageRoute(
//                                           builder: (_) => const Alerts()),
//                                     );
//                                   }
//                                 },
//                     );
//                   }
//                 : userProvider.user == null
//                     ? () async {
//                         _vibrate();
//                         isPhone ? await loginSheet() : await loginSheetTablet();
//                         if (context.read<UserProvider>().user == null) {
//                           return;
//                         }
//                         log("-----GET TAB CALLING");
//                         ApiResponse res = await context
//                             .read<StockDetailProviderNew>()
//                             .getTabData(symbol: symbol);
//                         try {
//                           if (res.status) {
//                             num alrtOn = navigatorKey.currentContext!
//                                     .read<StockDetailProviderNew>()
//                                     .tabRes
//                                     ?.isAlertAdded ??
//                                 0;
//                             if (alrtOn == 0) {
//                               await Future.delayed(
//                                   const Duration(milliseconds: 200));

//                               await _showAlertPopup(
//                                   navigatorKey.currentContext!, symbol);
//                             } else {
//                               Navigator.push(
//                                 navigatorKey.currentContext!,
//                                 MaterialPageRoute(
//                                     builder: (_) => const Alerts()),
//                               );
//                             }
//                           }
//                         } catch (e) {
//                           Utils().showLog("----$e-----");
//                         }
//                       }
//                     : alertOn == 0
//                         ? () async {
//                             _vibrate();

//                             await _showAlertPopup(
//                                 navigatorKey.currentContext!, symbol);

//                             // await askToSubscribe();
//                             // await _showAlertPopup(
//                             //     navigatorKey.currentContext!, symbol);
//                           }
//                         : () {
//                             Navigator.push(
//                               navigatorKey.currentContext!,
//                               MaterialPageRoute(builder: (_) => const Alerts()),
//                             );
//                           },

//             // onTap: userProvider.user == null
//             //     ? () async {
//             //         _vibrate();
//             //         isPhone ? await loginSheet() : await loginSheetTablet();
//             //         if (context.read<UserProvider>().user == null) {
//             //           return;
//             //         }
//             //         log("-----GET TAB CALLING");
//             //         ApiResponse res = await context
//             //             .read<StockDetailProviderNew>()
//             //             .getTabData(symbol: symbol);
//             //         try {
//             //           if (res.status) {
//             //             num alrtOn = navigatorKey.currentContext!
//             //                     .read<StockDetailProviderNew>()
//             //                     .tabRes
//             //                     ?.isAlertAdded ??
//             //                 0;
//             //             if (alrtOn == 0) {
//             //               await Future.delayed(
//             //                   const Duration(milliseconds: 200));
//             //               if (userProvider.user?.subscriptionPurchased == 0) {
//             //                 await askToSubscribe();
//             //               }
//             //               if (userProvider.user?.subscriptionPurchased == 1) {
//             //                 await _showAlertPopup(
//             //                     navigatorKey.currentContext!, symbol);
//             //               }
//             //             } else {
//             //               Navigator.push(
//             //                 navigatorKey.currentContext!,
//             //                 MaterialPageRoute(builder: (_) => const Alerts()),
//             //               );
//             //             }
//             //           }
//             //         } catch (e) {
//             //           Utils().showLog("----$e-----");
//             //         }
//             //       }
//             //     : alertOn == 0
//             //         ? () async {
//             //             _vibrate();
//             //             if (userProvider.user?.subscriptionPurchased == 0) {
//             //               await askToSubscribe();
//             //             }
//             //             if (userProvider.user?.subscriptionPurchased == 1) {
//             //               await _showAlertPopup(
//             //                   navigatorKey.currentContext!, symbol);
//             //             }

//             //             // await askToSubscribe();
//             //             // await _showAlertPopup(
//             //             //     navigatorKey.currentContext!, symbol);
//             //           }
//             //         : () {
//             //             Navigator.push(
//             //               navigatorKey.currentContext!,
//             //               MaterialPageRoute(builder: (_) => const Alerts()),
//             //             );
//             //           },
//           ),
//           const SpacerHorizontal(width: 10),
//           AlertWatchlistButton(
//             backgroundColor:
//                 watchlistOn == 0 ? ThemeColors.accent : ThemeColors.background,
//             iconData: Icons.star_border,
//             name: watchlistOn == 0 ? "Add to Watchlist" : "Watchlist Added",
//             onTap: showMembership
//                 ? () async {
//                     if (userProvider.user != null &&
//                         (purchased && isPresentWatchlist)) {
//                       _vibrate();
//                       watchlistOn == 0
//                           ? await context
//                               .read<StockDetailProviderNew>()
//                               .addToWishList()
//                           : Navigator.push(
//                               navigatorKey.currentContext!,
//                               MaterialPageRoute(builder: (_) => const Alerts()),
//                             );

//                       return;
//                     }

//                     // Subscription popUp
//                     askToSubscribe(
//                         onPressed: userProvider.user == null
//                             ? () async {
//                                 Navigator.pop(context);

//                                 _vibrate();
//                                 isPhone
//                                     ? await loginSheet()
//                                     : await loginSheetTablet();
//                                 if (context.read<UserProvider>().user == null) {
//                                   return;
//                                 }
//                                 ApiResponse res = await context
//                                     .read<StockDetailProviderNew>()
//                                     .getTabData(symbol: symbol);
//                                 try {
//                                   if (res.status) {
//                                     num wlistOn = navigatorKey.currentContext!
//                                             .read<StockDetailProviderNew>()
//                                             .tabRes
//                                             ?.isWatchListAdded ??
//                                         0;
//                                     if (wlistOn == 0) {
//                                       log("-----GET TAB CALLING");

//                                       if ((!purchased && !isPresentWatchlist)) {
//                                         await _subscribe();
//                                       }
//                                       if ((purchased && isPresentWatchlist)) {
//                                         await context
//                                             .read<StockDetailProviderNew>()
//                                             .addToWishList();
//                                       }
//                                     } else {
//                                       Navigator.push(
//                                         navigatorKey.currentContext!,
//                                         MaterialPageRoute(
//                                           builder: (_) => const WatchList(),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 } catch (e) {
//                                   Utils().showLog("----$e-----");
//                                 }
//                               }
//                             : watchlistOn == 0
//                                 ? () async {
//                                     Navigator.pop(context);

//                                     _vibrate();

//                                     if ((!purchased && !isPresentWatchlist)) {
//                                       await _subscribe();
//                                     }
//                                     if ((purchased && isPresentWatchlist)) {
//                                       await context
//                                           .read<StockDetailProviderNew>()
//                                           .addToWishList();
//                                     }
//                                   }
//                                 : () async {
//                                     Navigator.pop(context);

//                                     _vibrate();

//                                     if (!purchased && (!isPresentWatchlist)) {
//                                       await _subscribe();
//                                     }
//                                     if (purchased && (isPresentWatchlist)) {
//                                       Navigator.push(
//                                         navigatorKey.currentContext!,
//                                         MaterialPageRoute(
//                                           builder: (_) => const WatchList(),
//                                         ),
//                                       );
//                                     }
//                                   });

//                     // onTap: userProvider.user == null
//                     //             ? () async {
//                     //                 _vibrate();
//                     //                 isPhone ? await loginSheet() : await loginSheetTablet();
//                     //                 if (context.read<UserProvider>().user == null) {
//                     //                   return;
//                     //                 }
//                     //                 ApiResponse res = await context
//                     //                     .read<StockDetailProviderNew>()
//                     //                     .getTabData(symbol: symbol);
//                     //                 try {
//                     //                   if (res.status) {
//                     //                     num wlistOn = navigatorKey.currentContext!
//                     //                             .read<StockDetailProviderNew>()
//                     //                             .tabRes
//                     //                             ?.isWatchListAdded ??
//                     //                         0;
//                     //                     if (wlistOn == 0) {
//                     //                       log("-----GET TAB CALLING");

//                     //                       if (userProvider.user?.subscriptionPurchased == 0) {
//                     //                         await askToSubscribe();
//                     //                       }
//                     //                       if (userProvider.user?.subscriptionPurchased == 1) {
//                     //                         await context
//                     //                             .read<StockDetailProviderNew>()
//                     //                             .addToWishList();
//                     //                       }
//                     //                       // await askToSubscribe();

//                     //                       // await context
//                     //                       //     .read<StockDetailProviderNew>()
//                     //                       //     .addToWishList();
//                     //                     } else {
//                     //                       Navigator.push(
//                     //                         navigatorKey.currentContext!,
//                     //                         MaterialPageRoute(
//                     //                           builder: (_) => const WatchList(),
//                     //                         ),
//                     //                       );
//                     //                     }
//                     //                   }
//                     //                 } catch (e) {
//                     //                   Utils().showLog("----$e-----");
//                     //                 }
//                     //               }
//                     //             : watchlistOn == 0
//                     //                 ? () async {
//                     //                     _vibrate();
//                     //                     // await askToSubscribe();

//                     //                     // await context
//                     //                     //     .read<StockDetailProviderNew>()
//                     //                     //     .addToWishList();
//                     //                     if (userProvider.user?.subscriptionPurchased == 0) {
//                     //                       await askToSubscribe();
//                     //                     }
//                     //                     if (userProvider.user?.subscriptionPurchased == 1) {
//                     //                       await context
//                     //                           .read<StockDetailProviderNew>()
//                     //                           .addToWishList();
//                     //                     }
//                     //                   }
//                     //                 : () {
//                     //                     Navigator.push(
//                     //                       navigatorKey.currentContext!,
//                     //                       MaterialPageRoute(
//                     //                         builder: (_) => const WatchList(),
//                     //                       ),
//                     //                     );
//                     //                   };
//                   }
//                 : userProvider.user == null
//                     ? () async {
//                         _vibrate();
//                         isPhone ? await loginSheet() : await loginSheetTablet();
//                         if (context.read<UserProvider>().user == null) {
//                           return;
//                         }
//                         ApiResponse res = await context
//                             .read<StockDetailProviderNew>()
//                             .getTabData(symbol: symbol);
//                         try {
//                           if (res.status) {
//                             num wlistOn = navigatorKey.currentContext!
//                                     .read<StockDetailProviderNew>()
//                                     .tabRes
//                                     ?.isWatchListAdded ??
//                                 0;
//                             if (wlistOn == 0) {
//                               log("-----GET TAB CALLING");

//                               await context
//                                   .read<StockDetailProviderNew>()
//                                   .addToWishList();
//                             } else {
//                               Navigator.push(
//                                 navigatorKey.currentContext!,
//                                 MaterialPageRoute(
//                                   builder: (_) => const WatchList(),
//                                 ),
//                               );
//                             }
//                           }
//                         } catch (e) {
//                           Utils().showLog("----$e-----");
//                         }
//                       }
//                     : watchlistOn == 0
//                         ? () async {
//                             _vibrate();

//                             await context
//                                 .read<StockDetailProviderNew>()
//                                 .addToWishList();
//                           }
//                         : () {
//                             Navigator.push(
//                               navigatorKey.currentContext!,
//                               MaterialPageRoute(
//                                 builder: (_) => const WatchList(),
//                               ),
//                             );
//                           },

//             // onTap: userProvider.user == null
//             //     ? () async {
//             //         _vibrate();
//             //         isPhone ? await loginSheet() : await loginSheetTablet();
//             //         if (context.read<UserProvider>().user == null) {
//             //           return;
//             //         }
//             //         ApiResponse res = await context
//             //             .read<StockDetailProviderNew>()
//             //             .getTabData(symbol: symbol);
//             //         try {
//             //           if (res.status) {
//             //             num wlistOn = navigatorKey.currentContext!
//             //                     .read<StockDetailProviderNew>()
//             //                     .tabRes
//             //                     ?.isWatchListAdded ??
//             //                 0;
//             //             if (wlistOn == 0) {
//             //               log("-----GET TAB CALLING");

//             //               if (userProvider.user?.subscriptionPurchased == 0) {
//             //                 await askToSubscribe();
//             //               }
//             //               if (userProvider.user?.subscriptionPurchased == 1) {
//             //                 await context
//             //                     .read<StockDetailProviderNew>()
//             //                     .addToWishList();
//             //               }
//             //               // await askToSubscribe();

//             //               // await context
//             //               //     .read<StockDetailProviderNew>()
//             //               //     .addToWishList();
//             //             } else {
//             //               Navigator.push(
//             //                 navigatorKey.currentContext!,
//             //                 MaterialPageRoute(
//             //                   builder: (_) => const WatchList(),
//             //                 ),
//             //               );
//             //             }
//             //           }
//             //         } catch (e) {
//             //           Utils().showLog("----$e-----");
//             //         }
//             //       }
//             //     : watchlistOn == 0
//             //         ? () async {
//             //             _vibrate();
//             //             // await askToSubscribe();

//             //             // await context
//             //             //     .read<StockDetailProviderNew>()
//             //             //     .addToWishList();
//             //             if (userProvider.user?.subscriptionPurchased == 0) {
//             //               await askToSubscribe();
//             //             }
//             //             if (userProvider.user?.subscriptionPurchased == 1) {
//             //               await context
//             //                   .read<StockDetailProviderNew>()
//             //                   .addToWishList();
//             //             }
//             //           }
//             //         : () {
//             //             Navigator.push(
//             //               navigatorKey.currentContext!,
//             //               MaterialPageRoute(
//             //                 builder: (_) => const WatchList(),
//             //               ),
//             //             );
//             //           },
//           ),
//         ],
//       ),
//     );
//   }

//   Future _showAlertPopup(BuildContext context, String symbol) async {
//     // Navigator.push(
//     //   context,
//     //   createRoute(
//     // AlertPopUpDialog(
//     //   content: AlertPopup(
//     //     fromStockDetail: true,
//     //     symbol: symbol,
//     //   ),
//     // ),
//     //   ),
//     // );

//     showPlatformBottomSheet(
//       // backgroundColor: const Color.fromARGB(255, 23, 23, 23),
//       backgroundColor: ThemeColors.bottomsheetGradient,
//       context: context,
//       showClose: false,
//       content: AlertPopup(
//         fromStockDetail: true,
//         symbol: symbol,
//       ),
//     );

//     // showDialog(
//     //     context: context,
//     //     builder: (context) {
//     //       return AlertPopup(
//     //         fromStockDetail: true,
//     //         symbol: symbol,
//     //       );
//     //     });
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/service/ask_subscription.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:vibration/vibration.dart';
import '../../../../service/revenue_cat.dart';
import '../../../../utils/dialogs.dart';
import '../../../alerts/alerts.dart';
import '../../../auth/membershipAsk/ask.dart';
import 'alert_popup.dart';
import 'button.dart';

//
class AddToAlertWatchlist extends StatelessWidget {
  const AddToAlertWatchlist({super.key});

  void _vibrate() async {
    if (Platform.isAndroid) {
      bool isVibe = await Vibration.hasVibrator() ?? false;
      if (isVibe) {
        Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
      } else {
        Utils().showLog("$isVibe");
      }
    } else {
      HapticFeedback.lightImpact();
    }
  }

  Future _subscribe() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    Navigator.pop(navigatorKey.currentContext!);
    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      await RevenueCatService.initializeSubscription();
    }
  }

  Future _callTabAPI() async {
    String? symbol = navigatorKey.currentContext!
            .read<StockDetailProviderNew>()
            .tabRes
            ?.keyStats
            ?.symbol ??
        "";
    await navigatorKey.currentContext!
        .read<StockDetailProviderNew>()
        .getTabData(symbol: symbol);
  }

  @override
  Widget build(BuildContext context) {
    String? symbol =
        context.watch<StockDetailProviderNew>().tabRes?.keyStats?.symbol ?? "";
    num alertOn =
        context.watch<StockDetailProviderNew>().tabRes?.isAlertAdded ?? 0;
    num watchlistOn =
        context.watch<StockDetailProviderNew>().tabRes?.isWatchListAdded ?? 0;
    HomeProvider provider = context.watch<HomeProvider>();
    // HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = provider.extra?.membership?.purchased == 1;

    bool alertPermission = provider.extra?.membership?.permissions?.any(
            (element) => (element.key == "add-alert" && element.status == 1)) ??
        false;

    bool watchListPermission = provider.extra?.membership?.permissions?.any(
            (element) =>
                (element.key == "add-watchlist" && element.status == 1)) ??
        false;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Row(
        children: [
          AlertWatchlistButton(
            backgroundColor:
                alertOn == 0 ? ThemeColors.accent : ThemeColors.background,
            iconData: Icons.add_alert_outlined,
            name: alertOn == 0 ? "Add to Alerts" : "Alert Added",
            onTap: () async {
              UserProvider provider = context.read<UserProvider>();
              HomeProvider homeProvider = context.read<HomeProvider>();

              bool purchased = provider.user?.membership?.purchased == 1;
              bool isLocked = homeProvider.extra?.membership?.permissions?.any(
                    (element) =>
                        (element.key == "add-alert" && element.status == 0),
                  ) ??
                  false;

              if (purchased && isLocked) {
                bool havePermissions =
                    provider.user?.membership?.permissions?.any(
                          (element) => (element.key == "add-alert" &&
                              element.status == 1),
                        ) ??
                        false;

                isLocked = !havePermissions;
              }

              if (isLocked) {
                //For Membership
                Utils().showLog("---For Membership");
                if (provider.user != null && (purchased && alertPermission)) {
                  //Check if user is present and membership purchased and has Alert permission
                  Utils().showLog(
                      "---Check if user is present and membership purchased and has Alert permission");

                  if (alertOn == 0) {
                    _vibrate();
                    _showAlertPopup(navigatorKey.currentContext!, symbol);
                  } else {
                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(builder: (_) => const Alerts()),
                    );
                  }

                  return;
                }

                //Starting with asking Membership
                Utils().showLog("---Starting with asking Membership");

                askToSubscribe(
                  onPressed: () async {
                    if (provider.user == null) {
                      //Ask for Login
                      Utils().showLog("---Ask for Login");

                      isPhone ? await loginSheet() : await loginSheetTablet();
                      if (provider.user == null) {
                        return;
                      }
                      //Call Tab API to check if alert present or not
                      Utils().showLog(
                          "---Call Tab API to check if alert present or not");

                      await _callTabAPI();
                      await Future.delayed(const Duration(milliseconds: 200));
                      if ((!purchased && !alertPermission) ||
                          (purchased && !alertPermission)) {
                        await _subscribe();
                      }
                    } else {
                      //User is Logged In
                      Utils().showLog("---User is Logged In");
                      if ((!purchased && !alertPermission) ||
                          (purchased && !alertPermission)) {
                        await _subscribe();
                        return;
                      }

                      if (alertOn == 0) {
                        _vibrate();
                        _showAlertPopup(navigatorKey.currentContext!, symbol);
                      } else {
                        Navigator.push(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(builder: (_) => const Alerts()),
                        );
                      }
                    }
                  },
                );
              } else {
                //Normal Flow
                Utils().showLog("---Normal Flow");
                if (provider.user == null) {
                  //Ask for Login
                  Utils().showLog("---Ask for Login");

                  isPhone ? await loginSheet() : await loginSheetTablet();
                  if (provider.user == null) {
                    return;
                  }
                  //Call Tab API to check if alert present or not
                  Utils().showLog(
                      "---Call Tab API to check if alert present or not");

                  await _callTabAPI();
                } else {
                  //User is Logged In
                  Utils().showLog("---User is Logged In");

                  if (alertOn == 0) {
                    _vibrate();
                    _showAlertPopup(navigatorKey.currentContext!, symbol);
                  } else {
                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(builder: (_) => const Alerts()),
                    );
                  }
                }
              }
            },
          ),
          const SpacerHorizontal(width: 10),
          AlertWatchlistButton(
            backgroundColor:
                watchlistOn == 0 ? ThemeColors.accent : ThemeColors.background,
            iconData: Icons.star_border,
            name: watchlistOn == 0 ? "Add to Watchlist" : "Watchlist Added",
            onTap: () async {
              UserProvider provider = context.read<UserProvider>();
              HomeProvider homeProvider = context.read<HomeProvider>();

              bool purchased = provider.user?.membership?.purchased == 1;
              bool isLocked = homeProvider.extra?.membership?.permissions?.any(
                    (element) =>
                        (element.key == "add-watchlist" && element.status == 0),
                  ) ??
                  false;

              if (purchased && isLocked) {
                bool havePermissions =
                    provider.user?.membership?.permissions?.any(
                          (element) => (element.key == "add-watchlist" &&
                              element.status == 1),
                        ) ??
                        false;

                isLocked = !havePermissions;
              }

              if (isLocked) {
                //For Membership
                Utils().showLog("---For Membership");
                if (provider.user != null &&
                    (purchased && watchListPermission)) {
                  //Check if user is present and membership purchased and has Alert permission
                  Utils().showLog(
                      "---Check if user is present and membership purchased and has Alert permission");

                  if (watchlistOn == 0) {
                    _vibrate();
                    await context
                        .read<StockDetailProviderNew>()
                        .addToWishList();
                  } else {
                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(builder: (_) => const WatchList()),
                    );
                  }

                  return;
                }

                //Starting with asking Membership
                Utils().showLog("---Starting with asking Membership");

                askToSubscribe(
                  onPressed: () async {
                    if (provider.user == null) {
                      //Ask for Login
                      Utils().showLog("---Ask for Login");

                      isPhone ? await loginSheet() : await loginSheetTablet();
                      if (provider.user == null) {
                        return;
                      }
                      //Call Tab API to check if alert present or not
                      Utils().showLog(
                          "---Call Tab API to check if alert present or not");

                      await _callTabAPI();
                      await Future.delayed(const Duration(milliseconds: 200));
                      if ((!purchased && !watchListPermission) ||
                          (purchased && !watchListPermission)) {
                        await _subscribe();
                      }
                    } else {
                      //User is Logged In
                      Utils().showLog("---User is Logged In");
                      if ((!purchased && !watchListPermission) ||
                          (purchased && !watchListPermission)) {
                        await _subscribe();
                        return;
                      }

                      if (watchlistOn == 0) {
                        _vibrate();
                        await context
                            .read<StockDetailProviderNew>()
                            .addToWishList();
                      } else {
                        Navigator.push(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(builder: (_) => const WatchList()),
                        );
                      }
                    }
                  },
                );
              } else {
                //Normal Flow
                Utils().showLog("---Normal Flow");
                if (provider.user == null) {
                  //Ask for Login
                  Utils().showLog("---Ask for Login");

                  isPhone ? await loginSheet() : await loginSheetTablet();
                  if (provider.user == null) {
                    return;
                  }
                  //Call Tab API to check if alert present or not
                  Utils().showLog(
                      "---Call Tab API to check if alert present or not");

                  await _callTabAPI();
                } else {
                  //User is Logged In
                  Utils().showLog("---User is Logged In");

                  if (watchlistOn == 0) {
                    _vibrate();
                    await context
                        .read<StockDetailProviderNew>()
                        .addToWishList();
                  } else {
                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(builder: (_) => const WatchList()),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future _showAlertPopup(BuildContext context, String symbol) async {
    showPlatformBottomSheet(
      backgroundColor: ThemeColors.bottomsheetGradient,
      context: context,
      showClose: false,
      content: AlertPopup(
        fromStockDetail: true,
        symbol: symbol,
      ),
    );
  }
}
