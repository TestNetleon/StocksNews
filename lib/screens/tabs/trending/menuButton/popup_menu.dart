// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:provider/provider.dart';
import '../../../../routes/my_app.dart';
import '../../../../utils/utils.dart';
import '../../../auth/base/base_auth.dart';
import '../../../offerMembership/blackFriday/index.dart';
import '../../../offerMembership/christmas/index.dart';

class PopUpMenuButtonCommon extends StatelessWidget {
  final String symbol;
  final String alertString;
  final String watchlistString;
//
  final Function() onClickAlert, onClickWatchlist;
  const PopUpMenuButtonCommon({
    super.key,
    required this.symbol,
    required this.onClickAlert,
    required this.onClickWatchlist,
    required this.alertString,
    required this.watchlistString,
  });

  Future _subscribe() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null &&
        provider.user?.phone != '' &&
        provider.user?.membership?.purchased == 0) {
      // await RevenueCatService.initializeSubscription();
      // Navigator.push(
      //   navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (_) => const NewMembership(),
      //   ),
      // );
      closeKeyboard();
      if (provider.user?.showBlackFriday == true) {
        await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => const BlackFridayMembershipIndex(),
          ),
        );
      } else if (provider.user?.christmasMembership == true ||
          provider.user?.newYearMembership == true) {
        Navigator.push(
          navigatorKey.currentContext!,
          createRoute(
            const ChristmasMembershipIndex(),
          ),
        );
      } else {
        await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => const NewMembership(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    // HomeProvider homeProvider = context.watch<HomeProvider>();
    // bool purchased = provider.user?.membership?.purchased == 1;

    bool isPresentAlert = provider.user?.membership?.permissions?.any(
            (element) => (element.key == "add-alert" && element.status == 1)) ??
        false;

    // bool isPresentAlertE =
    //     subscription?.permissions?.any((element) => element == "add-alert") ??
    //         false;

    bool isPresentWatchlist = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "add-watchlist" && element.status == 1)) ??
        false;

    // bool isPresentWatchlistE = subscription?.permissions
    //         ?.any((element) => element == "add-watchlist") ??
    //     false;

    return PopupMenuButton<AddType>(
      constraints: BoxConstraints.loose(Size(200.sp, 170.sp)),
      iconSize: !isPhone ? 16.sp : 20.sp,
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert_rounded),
      color: ThemeColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.sp),
        // side: const BorderSide(color: ThemeColors.border),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AddType>>[
        PopupMenuItem<AddType>(
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
                        (element) =>
                            (element.key == "add-alert" && element.status == 1),
                      ) ??
                      false;

              isLocked = !havePermissions;
            }

            if (isLocked) {
              if (provider.user != null && (purchased && isPresentAlert)) {
                await onClickAlert();
                return;
              }

              // askToSubscribe(
              //   onPressed: () async {
              //     Navigator.pop(context);

              if (provider.user == null) {
                // isPhone ? await loginSheet() : await loginSheetTablet();
                await loginFirstSheet();
              }
              if (provider.user == null) {
                return;
              }
              if ((!purchased && !isPresentAlert) ||
                  (purchased && !isPresentAlert)) {
                await _subscribe();
              }

              if ((purchased && isPresentAlert)) {
                await onClickAlert();
              }
              //   },
              // );
            } else if (provider.user == null) {
              // isPhone ? await loginSheet() : await loginSheetTablet();
              await loginFirstSheet();

              if (context.read<UserProvider>().user == null) {
                return;
              }
              onClickAlert();
            } else {
              onClickAlert();
            }
          },
          value: AddType.alert,
          child: Row(
            children: [
              Icon(
                Icons.add_alert_outlined,
                size: !isPhone ? 18 : 16,
                color: ThemeColors.background,
              ),
              const SpacerHorizontal(width: 2),
              Text(
                alertString,
                style: stylePTSansBold(
                  fontSize: 14,
                  color: ThemeColors.background,
                ),
              ),
              Visibility(
                visible: alertString == "Alert Added",
                child: Padding(
                  padding: EdgeInsets.only(left: 2.sp),
                  child: Icon(
                    Icons.check,
                    size: !isPhone ? 18 : 16,
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 0),
        PopupMenuItem<AddType>(
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
              if (provider.user != null && (purchased && isPresentWatchlist)) {
                await onClickWatchlist();

                return;
              }

              // askToSubscribe(
              //   onPressed: () async {
              //     Navigator.pop(context);

              if (provider.user == null) {
                // isPhone ? await loginSheet() : await loginSheetTablet();
                await loginFirstSheet();
              }
              if (provider.user == null) {
                return;
              }
              if ((!purchased && !isPresentWatchlist) ||
                  (purchased && !isPresentWatchlist)) {
                await _subscribe();
              }
              if ((purchased && isPresentWatchlist)) {
                await onClickWatchlist();
              }
              //   },
              // );
            } else if (provider.user == null) {
              // isPhone ? await loginSheet() : await loginSheetTablet();
              await loginFirstSheet();

              if (context.read<UserProvider>().user == null) {
                return;
              }
              onClickWatchlist();
            } else {
              onClickWatchlist();
            }
          },
          value: AddType.watchlist,
          child: Row(
            children: [
              Icon(
                Icons.star_border,
                size: !isPhone ? 18 : 16,
                color: ThemeColors.background,
              ),
              const SpacerHorizontal(width: 2),
              Text(
                watchlistString,
                style: stylePTSansBold(
                    fontSize: 14, color: ThemeColors.background),
              ),
              Visibility(
                visible: watchlistString == "Watchlist Added",
                child: Padding(
                  padding: EdgeInsets.only(left: 2.sp),
                  child: Icon(
                    Icons.check,
                    size: !isPhone ? 18 : 16,
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
