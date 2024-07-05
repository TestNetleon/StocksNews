// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/service/ask_subscription.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:vibration/vibration.dart';
import '../../../../service/revenue_cat.dart';
import '../../../../utils/dialogs.dart';
import 'alert_popup.dart';
import 'button.dart';

//
class AddToAlertWatchlist extends StatelessWidget {
  final Subscription? subscription;

  const AddToAlertWatchlist({super.key, this.subscription});

  void _vibrate() async {
    if (Platform.isAndroid) {
      bool isVibe = await Vibration.hasVibrator() ?? false;
      if (isVibe) {
        // Vibration.vibrate(pattern: [0, 500], intensities: [255, 255]);
        Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
      } else {
        Utils().showLog("$isVibe");
      }
    } else {
      HapticFeedback.lightImpact();
    }
  }

  Future _subscribe() async {
    await RevenueCatService.initializeSubscription();

    // await popUpAlert(
    //   message: "setting your subscription",
    //   title: "NEW",
    //   onTap: () async {
    //     Navigator.pop(navigatorKey.currentContext!);
    //     await navigatorKey.currentContext!
    //         .read<UserProvider>()
    //         .updateUser(subscriptionPurchased: 1);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    String? symbol =
        context.watch<StockDetailProviderNew>().tabRes?.keyStats?.symbol ?? "";
    num alertOn =
        context.watch<StockDetailProviderNew>().tabRes?.isAlertAdded ?? 0;
    num watchlistOn =
        context.watch<StockDetailProviderNew>().tabRes?.isWatchListAdded ?? 0;
    UserProvider userProvider = context.watch<UserProvider>();

    bool purchased = userProvider.extra?.subscription?.purchased == 1;

    bool isPresentAlert = userProvider.extra?.subscription?.permissions
            ?.any((element) => element == "add-alert") ??
        false;

    bool isPresentAlertE =
        subscription?.permissions?.any((element) => element == "add-alert") ??
            false;

    bool isPresentWatchlist = userProvider.extra?.subscription?.permissions
            ?.any((element) => element == "add-alert") ??
        false;

    bool isPresentWatchlistE = subscription?.permissions
            ?.any((element) => element == "add-watchlist") ??
        false;

    log("$purchased, $isPresentAlert");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Row(
        children: [
          AlertWatchlistButton(
            backgroundColor:
                alertOn == 0 ? ThemeColors.accent : ThemeColors.background,
            iconData: Icons.add_alert_outlined,
            name: alertOn == 0 ? "Add to Alerts" : "Alert Added",

            onTap: () {
              //Condition - User present and membership purchased

              if (userProvider.user != null &&
                  ((purchased || subscription?.purchased == 1) &&
                      (isPresentAlert || isPresentAlertE))) {
                _vibrate();
                alertOn == 0
                    ? _showAlertPopup(navigatorKey.currentContext!, symbol)
                    : Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(builder: (_) => const Alerts()),
                      );
                return;
              }
              askToSubscribe(
                onPressed: userProvider.user == null
                    ? () async {
                        log("message");
                        Navigator.pop(context);
                        isPhone ? await loginSheet() : await loginSheetTablet();
                        if (context.read<UserProvider>().user == null) {
                          return;
                        }
                        log("-----GET TAB CALLING");
                        ApiResponse res = await context
                            .read<StockDetailProviderNew>()
                            .getTabData(symbol: symbol);
                        try {
                          if (res.status) {
                            num alrtOn = navigatorKey.currentContext!
                                    .read<StockDetailProviderNew>()
                                    .tabRes
                                    ?.isAlertAdded ??
                                0;
                            if (alrtOn == 0) {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              if (((!purchased ||
                                      subscription?.purchased == 0) &&
                                  (!isPresentAlert || !isPresentAlertE))) {
                                await _subscribe();
                              }
                              if (((purchased ||
                                      subscription?.purchased == 1) &&
                                  (isPresentAlert || isPresentAlertE))) {
                                await _showAlertPopup(
                                    navigatorKey.currentContext!, symbol);
                              }
                            } else {
                              Navigator.push(
                                navigatorKey.currentContext!,
                                MaterialPageRoute(
                                    builder: (_) => const Alerts()),
                              );
                            }
                          }
                        } catch (e) {
                          Utils().showLog("----$e-----");
                        }
                      }
                    : alertOn == 0
                        ? () async {
                            Navigator.pop(context);

                            _vibrate();
                            if (((!purchased || subscription?.purchased == 0) &&
                                (!isPresentAlert || !isPresentAlertE))) {
                              await _subscribe();
                            }
                            if (((purchased || subscription?.purchased == 1) &&
                                (isPresentAlert || isPresentAlertE))) {
                              await _showAlertPopup(
                                  navigatorKey.currentContext!, symbol);
                            }
                          }
                        : () async {
                            Navigator.pop(context);
                            _vibrate();
                            if (((!purchased || subscription?.purchased == 0) &&
                                (!isPresentAlert || !isPresentAlertE))) {
                              await _subscribe();
                            }
                            if (((purchased || subscription?.purchased == 1) &&
                                (isPresentAlert || isPresentAlertE))) {
                              // await _showAlertPopup(
                              //     navigatorKey.currentContext!, symbol);

                              Navigator.push(
                                navigatorKey.currentContext!,
                                MaterialPageRoute(
                                    builder: (_) => const Alerts()),
                              );
                            }
                          },
              );
            },

            // onTap: userProvider.user == null
            //     ? () async {
            //         _vibrate();
            //         isPhone ? await loginSheet() : await loginSheetTablet();
            //         if (context.read<UserProvider>().user == null) {
            //           return;
            //         }
            //         log("-----GET TAB CALLING");
            //         ApiResponse res = await context
            //             .read<StockDetailProviderNew>()
            //             .getTabData(symbol: symbol);
            //         try {
            //           if (res.status) {
            //             num alrtOn = navigatorKey.currentContext!
            //                     .read<StockDetailProviderNew>()
            //                     .tabRes
            //                     ?.isAlertAdded ??
            //                 0;
            //             if (alrtOn == 0) {
            //               await Future.delayed(
            //                   const Duration(milliseconds: 200));
            //               if (userProvider.user?.subscriptionPurchased == 0) {
            //                 await askToSubscribe();
            //               }
            //               if (userProvider.user?.subscriptionPurchased == 1) {
            //                 await _showAlertPopup(
            //                     navigatorKey.currentContext!, symbol);
            //               }
            //             } else {
            //               Navigator.push(
            //                 navigatorKey.currentContext!,
            //                 MaterialPageRoute(builder: (_) => const Alerts()),
            //               );
            //             }
            //           }
            //         } catch (e) {
            //           Utils().showLog("----$e-----");
            //         }
            //       }
            //     : alertOn == 0
            //         ? () async {
            //             _vibrate();
            //             if (userProvider.user?.subscriptionPurchased == 0) {
            //               await askToSubscribe();
            //             }
            //             if (userProvider.user?.subscriptionPurchased == 1) {
            //               await _showAlertPopup(
            //                   navigatorKey.currentContext!, symbol);
            //             }
            //             // await askToSubscribe();
            //             // await _showAlertPopup(
            //             //     navigatorKey.currentContext!, symbol);
            //           }
            //         : () {
            //             Navigator.push(
            //               navigatorKey.currentContext!,
            //               MaterialPageRoute(builder: (_) => const Alerts()),
            //             );
            //           },
          ),
          const SpacerHorizontal(width: 10),
          AlertWatchlistButton(
            backgroundColor:
                watchlistOn == 0 ? ThemeColors.accent : ThemeColors.background,
            iconData: Icons.star_border,
            name: watchlistOn == 0 ? "Add to Watchlist" : "Watchlist Added",
            onTap: () async {
              //Condition - User present and membership purchased
              if (userProvider.user != null &&
                  ((purchased || subscription?.purchased == 1) &&
                      (isPresentAlert || isPresentAlertE))) {
                _vibrate();
                watchlistOn == 0
                    ? await context
                        .read<StockDetailProviderNew>()
                        .addToWishList()
                    : Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(builder: (_) => const Alerts()),
                      );

                return;
              }

              // Subscription popUp
              askToSubscribe(
                  onPressed: userProvider.user == null
                      ? () async {
                          Navigator.pop(context);

                          _vibrate();
                          isPhone
                              ? await loginSheet()
                              : await loginSheetTablet();
                          if (context.read<UserProvider>().user == null) {
                            return;
                          }
                          ApiResponse res = await context
                              .read<StockDetailProviderNew>()
                              .getTabData(symbol: symbol);
                          try {
                            if (res.status) {
                              num wlistOn = navigatorKey.currentContext!
                                      .read<StockDetailProviderNew>()
                                      .tabRes
                                      ?.isWatchListAdded ??
                                  0;
                              if (wlistOn == 0) {
                                log("-----GET TAB CALLING");

                                if (((!purchased ||
                                        subscription?.purchased == 0) &&
                                    (!isPresentAlert || !isPresentAlertE))) {
                                  await _subscribe();
                                }
                                if (((purchased ||
                                        subscription?.purchased == 1) &&
                                    (isPresentAlert || isPresentAlertE))) {
                                  await context
                                      .read<StockDetailProviderNew>()
                                      .addToWishList();
                                }
                                // await askToSubscribe();

                                // await context
                                //     .read<StockDetailProviderNew>()
                                //     .addToWishList();
                              } else {
                                Navigator.push(
                                  navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (_) => const WatchList(),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            Utils().showLog("----$e-----");
                          }
                        }
                      : watchlistOn == 0
                          ? () async {
                              Navigator.pop(context);

                              _vibrate();

                              if (((!purchased ||
                                      subscription?.purchased == 0) &&
                                  (!isPresentAlert || !isPresentAlertE))) {
                                await _subscribe();
                              }
                              if (((purchased ||
                                      subscription?.purchased == 1) &&
                                  (isPresentAlert || isPresentAlertE))) {
                                await context
                                    .read<StockDetailProviderNew>()
                                    .addToWishList();
                              }
                            }
                          // : () {
                          //     Navigator.push(
                          //       navigatorKey.currentContext!,
                          //       MaterialPageRoute(
                          //         builder: (_) => const WatchList(),
                          //       ),
                          //     );
                          //   },

                          : () async {
                              Navigator.pop(context);

                              _vibrate();

                              if (((!purchased ||
                                      subscription?.purchased == 0) &&
                                  (!isPresentAlert || !isPresentAlertE))) {
                                await _subscribe();
                              }
                              if (((purchased ||
                                      subscription?.purchased == 1) &&
                                  (isPresentAlert || isPresentAlertE))) {
                                Navigator.push(
                                  navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (_) => const WatchList(),
                                  ),
                                );
                              }
                            });

              // onTap: userProvider.user == null
              //             ? () async {
              //                 _vibrate();
              //                 isPhone ? await loginSheet() : await loginSheetTablet();
              //                 if (context.read<UserProvider>().user == null) {
              //                   return;
              //                 }
              //                 ApiResponse res = await context
              //                     .read<StockDetailProviderNew>()
              //                     .getTabData(symbol: symbol);
              //                 try {
              //                   if (res.status) {
              //                     num wlistOn = navigatorKey.currentContext!
              //                             .read<StockDetailProviderNew>()
              //                             .tabRes
              //                             ?.isWatchListAdded ??
              //                         0;
              //                     if (wlistOn == 0) {
              //                       log("-----GET TAB CALLING");
              //                       if (userProvider.user?.subscriptionPurchased == 0) {
              //                         await askToSubscribe();
              //                       }
              //                       if (userProvider.user?.subscriptionPurchased == 1) {
              //                         await context
              //                             .read<StockDetailProviderNew>()
              //                             .addToWishList();
              //                       }
              //                       // await askToSubscribe();
              //                       // await context
              //                       //     .read<StockDetailProviderNew>()
              //                       //     .addToWishList();
              //                     } else {
              //                       Navigator.push(
              //                         navigatorKey.currentContext!,
              //                         MaterialPageRoute(
              //                           builder: (_) => const WatchList(),
              //                         ),
              //                       );
              //                     }
              //                   }
              //                 } catch (e) {
              //                   Utils().showLog("----$e-----");
              //                 }
              //               }
              //             : watchlistOn == 0
              //                 ? () async {
              //                     _vibrate();
              //                     // await askToSubscribe();
              //                     // await context
              //                     //     .read<StockDetailProviderNew>()
              //                     //     .addToWishList();
              //                     if (userProvider.user?.subscriptionPurchased == 0) {
              //                       await askToSubscribe();
              //                     }
              //                     if (userProvider.user?.subscriptionPurchased == 1) {
              //                       await context
              //                           .read<StockDetailProviderNew>()
              //                           .addToWishList();
              //                     }
              //                   }
              //                 : () {
              //                     Navigator.push(
              //                       navigatorKey.currentContext!,
              //                       MaterialPageRoute(
              //                         builder: (_) => const WatchList(),
              //                       ),
              //                     );
              //                   };
            },
            // onTap: userProvider.user == null
            //     ? () async {
            //         _vibrate();
            //         isPhone ? await loginSheet() : await loginSheetTablet();
            //         if (context.read<UserProvider>().user == null) {
            //           return;
            //         }
            //         ApiResponse res = await context
            //             .read<StockDetailProviderNew>()
            //             .getTabData(symbol: symbol);
            //         try {
            //           if (res.status) {
            //             num wlistOn = navigatorKey.currentContext!
            //                     .read<StockDetailProviderNew>()
            //                     .tabRes
            //                     ?.isWatchListAdded ??
            //                 0;
            //             if (wlistOn == 0) {
            //               log("-----GET TAB CALLING");
            //               if (userProvider.user?.subscriptionPurchased == 0) {
            //                 await askToSubscribe();
            //               }
            //               if (userProvider.user?.subscriptionPurchased == 1) {
            //                 await context
            //                     .read<StockDetailProviderNew>()
            //                     .addToWishList();
            //               }
            //               // await askToSubscribe();
            //               // await context
            //               //     .read<StockDetailProviderNew>()
            //               //     .addToWishList();
            //             } else {
            //               Navigator.push(
            //                 navigatorKey.currentContext!,
            //                 MaterialPageRoute(
            //                   builder: (_) => const WatchList(),
            //                 ),
            //               );
            //             }
            //           }
            //         } catch (e) {
            //           Utils().showLog("----$e-----");
            //         }
            //       }
            //     : watchlistOn == 0
            //         ? () async {
            //             _vibrate();
            //             // await askToSubscribe();
            //             // await context
            //             //     .read<StockDetailProviderNew>()
            //             //     .addToWishList();
            //             if (userProvider.user?.subscriptionPurchased == 0) {
            //               await askToSubscribe();
            //             }
            //             if (userProvider.user?.subscriptionPurchased == 1) {
            //               await context
            //                   .read<StockDetailProviderNew>()
            //                   .addToWishList();
            //             }
            //           }
            //         : () {
            //             Navigator.push(
            //               navigatorKey.currentContext!,
            //               MaterialPageRoute(
            //                 builder: (_) => const WatchList(),
            //               ),
            //             );
            //           },
          ),
        ],
      ),
    );
  }

  Future _showAlertPopup(BuildContext context, String symbol) async {
    // Navigator.push(
    //   context,
    //   createRoute(
    // AlertPopUpDialog(
    //   content: AlertPopup(
    //     fromStockDetail: true,
    //     symbol: symbol,
    //   ),
    // ),
    //   ),
    // );

    showPlatformBottomSheet(
      // backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      backgroundColor: ThemeColors.bottomsheetGradient,
      context: context,
      showClose: false,
      content: AlertPopup(
        fromStockDetail: true,
        symbol: symbol,
      ),
    );
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertPopup(
    //         fromStockDetail: true,
    //         symbol: symbol,
    //       );
    //     });
  }
}
