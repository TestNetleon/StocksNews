import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/auth/base/base_auth.dart';
import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
import 'package:stocks_news_new/screens/offerMembership/blackFriday/index.dart';
import 'package:stocks_news_new/screens/offerMembership/christmas/index.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SlidableMenuWidget extends StatefulWidget {
  final bool up;
  final int alertForBullish;

  final int alertForBearish;
  final int watchlistForBullish;
  final int watchlistForBearish;
  final Widget child;
  final int? index;
  final Function() onClickAlert, onClickWatchlist;

  const SlidableMenuWidget({
    super.key,
    this.up = true,
    required this.child,
    this.alertForBullish = 0,
    this.alertForBearish = 0,
    this.watchlistForBullish = 0,
    this.watchlistForBearish = 0,
    this.index,
    required this.onClickAlert,
    required this.onClickWatchlist,
  });

  @override
  State<SlidableMenuWidget> createState() => _SlidableMenuWidgetState();
}

class _SlidableMenuWidgetState extends State<SlidableMenuWidget>
    with SingleTickerProviderStateMixin {
  SlidableController? controller;

  @override
  void initState() {
    super.initState();

    controller = SlidableController(this);

    if ((widget.index ?? 1) == 0) {
      controller?.openTo(
        BorderSide.strokeAlignInside,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 1000),
      );

      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          // Check if the widget is still mounted
          controller?.close(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 2000),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future _subscribe() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
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
        await subscribe();
        // await Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => const NewMembership(),
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider provider = navigatorKey.currentContext!.watch<UserProvider>();

    return Slidable(
      controller: controller,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.7,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async => _onIsAlertClick(),
                    child: Container(
                      // color: const Color.fromARGB(255, 210, 191, 15),
                      color: ThemeColors.secondary100,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon(
                          //   widget.up
                          //       ? widget.alertForBullish == 1
                          //           ? Icons.check
                          //           : Icons.notification_important_outlined
                          //       : widget.alertForBearish == 1
                          //           ? Icons.check
                          //           : Icons.notification_important_outlined,
                          //   color: Colors.black,
                          // ),
                          Image.asset(
                            Images.alerts,
                            width: 32,
                            height: 32,
                          ),
                          const SpacerVertical(height: 5),
                          Text(
                            textAlign: TextAlign.center,
                            widget.up
                                ? widget.alertForBullish == 1
                                    ? 'Alert Added     '
                                    : 'Add to Alerts    '
                                : widget.alertForBearish == 1
                                    ? 'Alert Added     '
                                    : 'Add to Alerts    ',
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SpacerHorizontal(width: 1),
                Expanded(
                  child: GestureDetector(
                    onTap: () async => _onIsWatchListClick(),
                    child: Container(
                      // color: ThemeColors.accent,
                      color: ThemeColors.secondary100,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon(
                          //   widget.up
                          //       ? widget.watlistForBullish == 1
                          //           ? Icons.check
                          //           : Icons.star_border
                          //       : widget.watlistForBearish == 1
                          //           ? Icons.check
                          //           : Icons.star_border,
                          //   color: Colors.black,
                          // ),
                          Image.asset(Images.watchlist, width: 32, height: 32),
                          const SpacerVertical(height: 5),
                          Text(
                            textAlign: TextAlign.center,
                            widget.up
                                ? widget.watchlistForBullish == 1
                                    ? 'Watchlist Added '
                                    : 'Add to Watchlist'
                                : widget.watchlistForBearish == 1
                                    ? 'Watchlist Added '
                                    : 'Add to Watchlist',
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      child: widget.child,
    );
  }

  Future _onIsAlertClick() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    Utils().showLog("USER LOGIN REQUIRED ${provider.user?.email}");
    if (provider.user == null) {
      // isPhone ? await loginSheet() : await loginSheetTablet();
      await loginFirstSheet();
    }
    if (provider.user == null) {
      return;
    }
    HomeProvider homeProvider =
        navigatorKey.currentContext!.read<HomeProvider>();
    bool isPresentAlert = provider.user?.membership?.permissions?.any(
            (element) => (element.key == "add-alert" && element.status == 1)) ??
        false;

    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) => (element.key == "add-alert" && element.status == 0),
        ) ??
        false;
    Utils().showLog("is Locked $isLocked");
    if (purchased && isLocked) {
      Utils().showLog(
          "Entered because its purchased and locked ${purchased && isLocked}");

      bool havePermissions = provider.user?.membership?.permissions?.any(
            (element) => (element.key == "add-alert" && element.status == 1),
          ) ??
          false;
      isLocked = !havePermissions;
      Utils().showLog("is Locked $isLocked");
    }

    if (isLocked) {
      Utils().showLog("Checking for is locked condition");

      if (provider.user != null && (purchased && isPresentAlert)) {
        await widget.onClickAlert();
        return;
      }

      // askToSubscribe(
      //   onPressed: () async {
      //     Navigator.pop(context);

      if ((!purchased && !isPresentAlert) || (purchased && !isPresentAlert)) {
        Utils().showLog(
            "is Purchased $purchased, is Present is permissions $isPresentAlert");

        await _subscribe();
      }

      if ((purchased && isPresentAlert)) {
        await widget.onClickAlert();
      }
      //   },
      // );
    } else if (provider.user == null) {
      // isPhone ? await loginSheet() : await loginSheetTablet();

      await loginFirstSheet();

      if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
        return;
      }
      widget.onClickAlert();
    } else {
      widget.onClickAlert();
    }
  }

  Future _onIsWatchListClick() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    if (provider.user == null) {
      // isPhone ? await loginSheet() : await loginSheetTablet();
      await loginFirstSheet();
    }
    if (provider.user == null) {
      return;
    }
    HomeProvider homeProvider =
        navigatorKey.currentContext!.read<HomeProvider>();
    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) => (element.key == "add-watchlist" && element.status == 0),
        ) ??
        false;

    bool isPresentWatchlist = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "add-watchlist" && element.status == 1)) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "add-watchlist" && element.status == 1),
          ) ??
          false;
      isLocked = !havePermissions;
    }
    if (isLocked) {
      if (provider.user != null && (purchased && isPresentWatchlist)) {
        await widget.onClickWatchlist();

        return;
      }

      // askToSubscribe(
      //   onPressed: () async {
      //     Navigator.pop(context);

      if ((!purchased && !isPresentWatchlist) ||
          (purchased && !isPresentWatchlist)) {
        await _subscribe();
      }
      if ((purchased && isPresentWatchlist)) {
        await widget.onClickWatchlist();
      }
      //   },
      // );
    } else if (provider.user == null) {
      // isPhone ? await loginSheet() : await loginSheetTablet();
      await loginFirstSheet();

      if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
        return;
      }
      widget.onClickWatchlist();
    } else {
      widget.onClickWatchlist();
    }
  }
}
