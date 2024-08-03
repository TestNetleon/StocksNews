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
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:vibration/vibration.dart';
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
    // Navigator.pop(navigatorKey.currentContext!);
    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      // await RevenueCatService.initializeSubscription();
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const NewMembership(),
        ),
      );
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

    // bool purchased = provider.extra?.membership?.purchased == 1;

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

                // askToSubscribe(
                //   onPressed: () async {
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
                //   },
                // );
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

                // askToSubscribe(
                //   onPressed: () async {
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
                //   },
                // );
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
