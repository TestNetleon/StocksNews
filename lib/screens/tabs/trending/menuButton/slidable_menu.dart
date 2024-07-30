// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import '../../../../providers/home_provider.dart';
// import '../../../../providers/user_provider.dart';
// import '../../../../route/my_app.dart';
// import '../../../../utils/colors.dart';
// import '../../../auth/login/login_sheet.dart';
// import '../../../auth/login/login_sheet_tablet.dart';
// import '../../../auth/membershipAsk/ask.dart';
// import '../../../membership_new/membership.dart';

// class SlidableMenuWidget extends StatelessWidget {
//   final bool up;
//   final int alertForBullish;

//   final int alertForBearish;
//   final int watlistForBullish;
//   final int watlistForBearish;
//   final Widget child;
//   final Function() onClickAlert, onClickWatchlist;

//   const SlidableMenuWidget({
//     super.key,
//     this.up = true,
//     required this.child,
//     this.alertForBullish = 0,
//     this.alertForBearish = 0,
//     this.watlistForBullish = 0,
//     this.watlistForBearish = 0,
//     required this.onClickAlert,
//     required this.onClickWatchlist,
//   });
//   Future _subscribe() async {
//     UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

//     if (provider.user?.phone == null || provider.user?.phone == '') {
//       await membershipLogin();
//     }
//     if (provider.user?.phone != null && provider.user?.phone != '') {
//       // await RevenueCatService.initializeSubscription();
//       Navigator.push(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (_) => const NewMembership(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider provider = context.watch<UserProvider>();

//     bool isPresentAlert = provider.user?.membership?.permissions?.any(
//             (element) => (element.key == "add-alert" && element.status == 1)) ??
//         false;

//     bool isPresentWatchlist = provider.user?.membership?.permissions?.any(
//             (element) =>
//                 (element.key == "add-watchlist" && element.status == 1)) ??
//         false;

//     return Slidable(
//       key: const ValueKey(0),
//       endActionPane: ActionPane(
//         motion: const ScrollMotion(),
//         extentRatio: 0.8,
//         children: [
//           SlidableAction(
//             autoClose: false,
//             onPressed: (context) async {
//               UserProvider provider =
//                   navigatorKey.currentContext!.read<UserProvider>();
//               HomeProvider homeProvider =
//                   navigatorKey.currentContext!.read<HomeProvider>();

//               bool purchased = provider.user?.membership?.purchased == 1;
//               bool isLocked = homeProvider.extra?.membership?.permissions?.any(
//                     (element) =>
//                         (element.key == "add-alert" && element.status == 0),
//                   ) ??
//                   false;

//               if (purchased && isLocked) {
//                 bool havePermissions =
//                     provider.user?.membership?.permissions?.any(
//                           (element) => (element.key == "add-alert" &&
//                               element.status == 1),
//                         ) ??
//                         false;

//                 isLocked = !havePermissions;
//               }

//               if (isLocked) {
//                 if (provider.user != null && (purchased && isPresentAlert)) {
//                   await onClickAlert();
//                   return;
//                 }

//                 // askToSubscribe(
//                 //   onPressed: () async {
//                 //     Navigator.pop(context);

//                 if (provider.user == null) {
//                   isPhone ? await loginSheet() : await loginSheetTablet();
//                 }
//                 if (provider.user == null) {
//                   return;
//                 }
//                 if ((!purchased && !isPresentAlert) ||
//                     (purchased && !isPresentAlert)) {
//                   await _subscribe();
//                 }

//                 if ((purchased && isPresentAlert)) {
//                   await onClickAlert();
//                 }
//                 //   },
//                 // );
//               } else if (provider.user == null) {
//                 isPhone ? await loginSheet() : await loginSheetTablet();

//                 if (navigatorKey.currentContext!.read<UserProvider>().user ==
//                     null) {
//                   return;
//                 }
//                 onClickAlert();
//               } else {
//                 onClickAlert();
//               }
//             },
//             backgroundColor: const Color.fromARGB(255, 210, 191, 15),
//             foregroundColor: Colors.black,
//             icon: up
//                 ? alertForBullish == 1
//                     ? Icons.check
//                     : Icons.notification_important_outlined
//                 : alertForBearish == 1
//                     ? Icons.check
//                     : Icons.notification_important_outlined,
//             label: up
//                 ? alertForBullish == 1
//                     ? 'Alert Added'
//                     : 'Add to Alert'
//                 : alertForBearish == 1
//                     ? 'Alert Added'
//                     : 'Add to Alert',
//           ),
//           SlidableAction(
//             autoClose: false,
//             backgroundColor: ThemeColors.accent,
//             onPressed: (context) async {
//               UserProvider provider =
//                   navigatorKey.currentContext!.read<UserProvider>();
//               HomeProvider homeProvider =
//                   navigatorKey.currentContext!.read<HomeProvider>();
//               bool purchased = provider.user?.membership?.purchased == 1;
//               bool isLocked = homeProvider.extra?.membership?.permissions?.any(
//                     (element) =>
//                         (element.key == "add-watchlist" && element.status == 0),
//                   ) ??
//                   false;
//               if (purchased && isLocked) {
//                 bool havePermissions =
//                     provider.user?.membership?.permissions?.any(
//                           (element) => (element.key == "add-watchlist" &&
//                               element.status == 1),
//                         ) ??
//                         false;
//                 isLocked = !havePermissions;
//               }
//               if (isLocked) {
//                 if (provider.user != null &&
//                     (purchased && isPresentWatchlist)) {
//                   await onClickWatchlist();

//                   return;
//                 }

//                 // askToSubscribe(
//                 //   onPressed: () async {
//                 //     Navigator.pop(context);

//                 if (provider.user == null) {
//                   isPhone ? await loginSheet() : await loginSheetTablet();
//                 }
//                 if (provider.user == null) {
//                   return;
//                 }
//                 if ((!purchased && !isPresentWatchlist) ||
//                     (purchased && !isPresentWatchlist)) {
//                   await _subscribe();
//                 }
//                 if ((purchased && isPresentWatchlist)) {
//                   await onClickWatchlist();
//                 }
//                 //   },
//                 // );
//               } else if (provider.user == null) {
//                 isPhone ? await loginSheet() : await loginSheetTablet();

//                 if (navigatorKey.currentContext!.read<UserProvider>().user ==
//                     null) {
//                   return;
//                 }
//                 onClickWatchlist();
//               } else {
//                 onClickWatchlist();
//               }
//             },
//             foregroundColor: Colors.black,
//             icon: up
//                 ? watlistForBullish == 1
//                     ? Icons.check
//                     : Icons.star_border
//                 : watlistForBearish == 1
//                     ? Icons.check
//                     : Icons.star_border,
//             label: up
//                 ? watlistForBullish == 1
//                     ? 'Watchlist Added'
//                     : 'Add to Watchlist'
//                 : watlistForBearish == 1
//                     ? 'Watchlist Added'
//                     : 'Add to Watchlist',
//             borderRadius: const BorderRadius.only(
//               topRight: Radius.circular(5),
//               bottomRight: Radius.circular(5),
//             ),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../providers/home_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../route/my_app.dart';
import '../../../../utils/colors.dart';
import '../../../auth/login/login_sheet.dart';
import '../../../auth/login/login_sheet_tablet.dart';
import '../../../auth/membershipAsk/ask.dart';
import '../../../membership_new/membership.dart';

class SlidableMenuWidget extends StatefulWidget {
  final bool up;
  final int alertForBullish;

  final int alertForBearish;
  final int watlistForBullish;
  final int watlistForBearish;
  final Widget child;
  final int? index;
  final Function() onClickAlert, onClickWatchlist;

  const SlidableMenuWidget({
    super.key,
    this.up = true,
    required this.child,
    this.alertForBullish = 0,
    this.alertForBearish = 0,
    this.watlistForBullish = 0,
    this.watlistForBearish = 0,
    this.index,
    required this.onClickAlert,
    required this.onClickWatchlist,
  });

  @override
  State<SlidableMenuWidget> createState() => _SlidableMenuWidgetState();
}

class _SlidableMenuWidgetState extends State<SlidableMenuWidget>
    with SingleTickerProviderStateMixin {
  late final SlidableController? controller = SlidableController(this);

  @override
  void initState() {
    super.initState();

    if (controller != null && (widget.index ?? 1) == 0) {
      controller?.openTo(
        BorderSide.strokeAlignInside,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 1000),
      );

      Timer(const Duration(milliseconds: 1000), () {
        controller?.close(
          curve: Curves.linear,
          duration: const Duration(milliseconds: 2000),
        );
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
      // await RevenueCatService.initializeSubscription();
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const NewMembership(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = navigatorKey.currentContext!.watch<UserProvider>();

    bool isPresentAlert = provider.user?.membership?.permissions?.any(
            (element) => (element.key == "add-alert" && element.status == 1)) ??
        false;

    bool isPresentWatchlist = provider.user?.membership?.permissions?.any(
            (element) =>
                (element.key == "add-watchlist" && element.status == 1)) ??
        false;

    return Slidable(
      controller: controller,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.8,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onIsAlertClick(context, isPresentAlert),
                    child: Container(
                      color: const Color.fromARGB(255, 210, 191, 15),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.up
                                ? widget.alertForBullish == 1
                                    ? Icons.check
                                    : Icons.notification_important_outlined
                                : widget.alertForBearish == 1
                                    ? Icons.check
                                    : Icons.notification_important_outlined,
                            color: Colors.black,
                          ),
                          const SpacerVertical(height: 5),
                          Text(
                            textAlign: TextAlign.center,
                            widget.up
                                ? widget.alertForBullish == 1
                                    ? 'Alert Added     '
                                    : 'Add to Alert    '
                                : widget.alertForBearish == 1
                                    ? 'Alert Added     '
                                    : 'Add to Alert    ',
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        _onIsWatchListClick(context, isPresentWatchlist),
                    child: Container(
                      color: ThemeColors.accent,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.up
                                ? widget.watlistForBullish == 1
                                    ? Icons.check
                                    : Icons.star_border
                                : widget.watlistForBearish == 1
                                    ? Icons.check
                                    : Icons.star_border,
                            color: Colors.black,
                          ),
                          const SpacerVertical(height: 5),
                          Text(
                            textAlign: TextAlign.center,
                            widget.up
                                ? widget.watlistForBullish == 1
                                    ? 'Watchlist Added '
                                    : 'Add to Watchlist'
                                : widget.watlistForBearish == 1
                                    ? 'Watchlist Added '
                                    : 'Add to Watchlist',
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: Colors.black,
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

          // SlidableAction(
          //   autoClose: false,
          //   onPressed: (context) async {
          //     UserProvider provider =
          //         navigatorKey.currentContext!.read<UserProvider>();
          //     HomeProvider homeProvider =
          //         navigatorKey.currentContext!.read<HomeProvider>();

          //     bool purchased = provider.user?.membership?.purchased == 1;
          //     bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          //           (element) =>
          //               (element.key == "add-alert" && element.status == 0),
          //         ) ??
          //         false;

          //     if (purchased && isLocked) {
          //       bool havePermissions =
          //           provider.user?.membership?.permissions?.any(
          //                 (element) => (element.key == "add-alert" &&
          //                     element.status == 1),
          //               ) ??
          //               false;

          //       isLocked = !havePermissions;
          //     }

          //     if (isLocked) {
          //       if (provider.user != null && (purchased && isPresentAlert)) {
          //         await widget.onClickAlert();
          //         return;
          //       }

          //       // askToSubscribe(
          //       //   onPressed: () async {
          //       //     Navigator.pop(context);

          //       if (provider.user == null) {
          //         isPhone ? await loginSheet() : await loginSheetTablet();
          //       }
          //       if (provider.user == null) {
          //         return;
          //       }
          //       if ((!purchased && !isPresentAlert) ||
          //           (purchased && !isPresentAlert)) {
          //         await _subscribe();
          //       }

          //       if ((purchased && isPresentAlert)) {
          //         await widget.onClickAlert();
          //       }
          //       //   },
          //       // );
          //     } else if (provider.user == null) {
          //       isPhone ? await loginSheet() : await loginSheetTablet();

          //       if (navigatorKey.currentContext!.read<UserProvider>().user ==
          //           null) {
          //         return;
          //       }
          //       widget.onClickAlert();
          //     } else {
          //       widget.onClickAlert();
          //     }
          //   },
          //   backgroundColor: const Color.fromARGB(255, 210, 191, 15),
          //   foregroundColor: Colors.black,
          //   icon: widget.up
          //       ? widget.alertForBullish == 1
          //           ? Icons.check
          //           : Icons.notification_important_outlined
          //       : widget.alertForBearish == 1
          //           ? Icons.check
          //           : Icons.notification_important_outlined,
          //   label: widget.up
          //       ? widget.alertForBullish == 1
          //           ? 'Alert Added'
          //           : 'Add to Alert'
          //       : widget.alertForBearish == 1
          //           ? 'Alert Added'
          //           : 'Add to Alert',
          // ),
          // SlidableAction(
          //   autoClose: false,
          //   backgroundColor: ThemeColors.accent,
          // onPressed: (context) async {
          //   UserProvider provider =
          //       navigatorKey.currentContext!.read<UserProvider>();
          //   HomeProvider homeProvider =
          //       navigatorKey.currentContext!.read<HomeProvider>();
          //   bool purchased = provider.user?.membership?.purchased == 1;
          //   bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          //         (element) =>
          //             (element.key == "add-watchlist" && element.status == 0),
          //       ) ??
          //       false;
          //   if (purchased && isLocked) {
          //     bool havePermissions =
          //         provider.user?.membership?.permissions?.any(
          //               (element) => (element.key == "add-watchlist" &&
          //                   element.status == 1),
          //             ) ??
          //             false;
          //     isLocked = !havePermissions;
          //   }
          //   if (isLocked) {
          //     if (provider.user != null &&
          //         (purchased && isPresentWatchlist)) {
          //       await widget.onClickWatchlist();

          //       return;
          //     }

          //     // askToSubscribe(
          //     //   onPressed: () async {
          //     //     Navigator.pop(context);

          //     if (provider.user == null) {
          //       isPhone ? await loginSheet() : await loginSheetTablet();
          //     }
          //     if (provider.user == null) {
          //       return;
          //     }
          //     if ((!purchased && !isPresentWatchlist) ||
          //         (purchased && !isPresentWatchlist)) {
          //       await _subscribe();
          //     }
          //     if ((purchased && isPresentWatchlist)) {
          //       await widget.onClickWatchlist();
          //     }
          //     //   },
          //     // );
          //   } else if (provider.user == null) {
          //     isPhone ? await loginSheet() : await loginSheetTablet();

          //     if (navigatorKey.currentContext!.read<UserProvider>().user ==
          //         null) {
          //       return;
          //     }
          //     widget.onClickWatchlist();
          //   } else {
          //     widget.onClickWatchlist();
          //   }
          // },
          //   foregroundColor: Colors.black,
          //   icon: widget.up
          //       ? widget.watlistForBullish == 1
          //           ? Icons.check
          //           : Icons.star_border
          //       : widget.watlistForBearish == 1
          //           ? Icons.check
          //           : Icons.star_border,
          //   label: widget.up
          //       ? widget.watlistForBullish == 1
          //           ? 'Watchlist Added'
          //           : 'Add to Watchlist'
          //       : widget.watlistForBearish == 1
          //           ? 'Watchlist Added'
          //           : 'Add to Watchlist',
          //   borderRadius: const BorderRadius.only(
          //     topRight: Radius.circular(5),
          //     bottomRight: Radius.circular(5),
          //   ),
          // ),
        ],
      ),
      child: widget.child,
    );
  }

  void _onIsAlertClick(context, isPresentAlert) async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    HomeProvider homeProvider =
        navigatorKey.currentContext!.read<HomeProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) => (element.key == "add-alert" && element.status == 0),
        ) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
            (element) => (element.key == "add-alert" && element.status == 1),
          ) ??
          false;

      isLocked = !havePermissions;
    }

    if (isLocked) {
      if (provider.user != null && (purchased && isPresentAlert)) {
        await widget.onClickAlert();
        return;
      }

      // askToSubscribe(
      //   onPressed: () async {
      //     Navigator.pop(context);

      if (provider.user == null) {
        isPhone ? await loginSheet() : await loginSheetTablet();
      }
      if (provider.user == null) {
        return;
      }
      if ((!purchased && !isPresentAlert) || (purchased && !isPresentAlert)) {
        await _subscribe();
      }

      if ((purchased && isPresentAlert)) {
        await widget.onClickAlert();
      }
      //   },
      // );
    } else if (provider.user == null) {
      isPhone ? await loginSheet() : await loginSheetTablet();

      if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
        return;
      }
      widget.onClickAlert();
    } else {
      widget.onClickAlert();
    }
  }

  void _onIsWatchListClick(context, isPresentWatchlist) async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    HomeProvider homeProvider =
        navigatorKey.currentContext!.read<HomeProvider>();
    bool purchased = provider.user?.membership?.purchased == 1;
    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
          (element) => (element.key == "add-watchlist" && element.status == 0),
        ) ??
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

      if (provider.user == null) {
        isPhone ? await loginSheet() : await loginSheetTablet();
      }
      if (provider.user == null) {
        return;
      }
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
      isPhone ? await loginSheet() : await loginSheetTablet();

      if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
        return;
      }
      widget.onClickWatchlist();
    } else {
      widget.onClickWatchlist();
    }
  }
}
