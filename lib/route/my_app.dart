// ignore_for_file: unused_element

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/dummy.dart';
import 'package:stocks_news_new/route/routes.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
import 'package:stocks_news_new/screens/help/deeplinks/deeplink_data.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
// import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

final _appLinks = AppLinks();
//
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({this.initialUri, super.key});
  final Uri? initialUri;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;

  bool _initialDeepLinks = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool connection = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getInitialReferralsIfAny();
      getInitialDeeplinkWhenAppOpen();
      startListeningForDeepLinks();
      // if (Platform.isIOS) _getAppLinks();
      // checkFirebaseDeepLinks();
      // setState(() {});
    });
  }


  void getInitialReferralsIfAny() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      Preference.saveDataList(
        DeeplinkData(
          uri: initialLink.link,
          from: "FirebaseDynamicLinks onLink received on starting/app open.",
          onDeepLink: onDeepLinking,
        ),
      );

      final Uri deepLink = initialLink.link;
      if (deepLink.path.contains("page.link") ||
          deepLink.path.contains("/install") ||
          deepLink.path.contains("?code=") ||
          deepLink.path.contains("?referrer=") ||
          deepLink.path.contains("?ref=") ||
          deepLink.path.contains("?referral_code=")) {
        // onDeepLinking = true;

        String? referralCode = deepLink.queryParameters['code'];
        if (referralCode == null || referralCode == '') {
          referralCode = deepLink.queryParameters['referrer'];
        }
        if (referralCode == null || referralCode == '') {
          referralCode = deepLink.queryParameters['ref'];
        }
        if (referralCode == null || referralCode == '') {
          referralCode = deepLink.queryParameters['referral_code'];
        }
        bool isFirstOpen = await Preference.isFirstOpen();
        String? code = await Preference.getReferral();

        if (referralCode != null &&
            referralCode != "" &&
            code == null &&
            isFirstOpen) {
          Preference.saveReferral(referralCode);
          Timer(const Duration(seconds: 4), () {
            if (navigatorKey.currentContext!.read<UserProvider>().user ==
                null) {
              signupSheet();
              // onDeepLinking = false;
            }
          });
          FirebaseAnalytics.instance.logEvent(
            name: 'referrals',
            parameters: {'referral_code': referralCode},
          );
        }
      }
    }
  }
  // -------- Initial Deeplinks For Referral Ended ---------------

  // -------- Initial Deeplinks when App Opened Started ---------------
  void getInitialDeeplinkWhenAppOpen() async {
    Uri? initialUri = await _appLinks.getInitialLink();
    Preference.saveDataList(
      DeeplinkData(
        uri: initialUri,
        from: "AppLinks getInitialLink on starting/app open.",
        onDeepLink: onDeepLinking,
      ),
    );
    if (initialUri != null) {
      String type = containsSpecificPath(initialUri);
      _initialDeepLinks = true;
      onDeepLinking = (type == "login" || type == "signUp") ? false : true;
      handleDeepLinkNavigation(uri: initialUri);
      Timer(const Duration(milliseconds: 500), () {
        _initialDeepLinks = false;
      });
    }
  }
  // -------- Initial Deeplinks when App Opened Ended ---------------

  // -------- Listen for incoming deeplinks Started ---------------
  void startListeningForDeepLinks() {
    _appLinks.uriLinkStream.listen((event) {
      if (event.toString().contains("app.stocks.news://")) return;
      Preference.saveDataList(
        DeeplinkData(
          uri: event,
          from: "AppLinks listened on _appLinks.uriLinkStream.listen",
          onDeepLink: onDeepLinking,
        ),
      );
      if (onDeepLinking || _initialDeepLinks) return;

      String type = containsSpecificPath(event);
      onDeepLinking = (type == "login" || type == "signUp") ? false : true;
      handleDeepLinkNavigation(uri: event);

      // bool isRef = event.toString().contains("/install") ||
      //     event.toString().contains(".page.link") ||
      //     event.toString().contains("app.stocks.news://");

      // if (isRef) {
      //   return;
      // }

      // if (onDeepLinking == true) return;
      // onDeepLinking = true;

      // String type = containsSpecificPath(event);
      // String slug = extractLastPathComponent(event);

      // if (_appLifecycleState == null) {
      //   Timer(const Duration(seconds: 4), () {
      //     navigation(
      //       uri: event,
      //       slug: slug,
      //       type: type,
      //       fromBackground: false,
      //       from: "_appLinks.uriLinkStream.listen BACKGROUND condition",
      //     );
      //     // onDeepLinking = false;
      //     Timer(const Duration(seconds: 3), () {
      //       onDeepLinking = false;
      //     });
      //   });
      // } else {
      //   Timer(const Duration(seconds: 1), () {
      //     navigation(
      //       uri: event,
      //       slug: slug,
      //       type: type,
      //       from: "_appLinks.uriLinkStream.listen NORMAL Condition",
      //     );
      //   });
      // }
    });
  }
  // -------- Listen for incoming deeplinks Ended ---------------

  //   String? initialRoute;
//   String? slug;
//   void checkFirebaseDeepLinks() async {
//     // FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
//     //   final Uri deepLink = pendingDynamicLinkData.link;
//     //   log(
//     //     "Link Received onListen ** => ${"\n\n"}${deepLink.path}${"\n"}$deepLink${"\n"}",
//     //   );
//     //   if (onDeepLinking == true) return;
//     //   onDeepLinking = true;
//     //   Preference.saveDataList(
//     //     DeeplinkData(
//     //       uri: deepLink,
//     //       from: "FirebaseDynamicLinks onLink received on Listen.",
//     //     ),
//     //   );
//     //   navigateDeepLinks(uri: deepLink);
//     // });
//     final PendingDynamicLinkData? initialLink =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     if (initialLink != null) {
//       if (onDeepLinking == true) return;
//       onDeepLinking = true;
//       Preference.saveDataList(
//         DeeplinkData(
//           uri: initialLink.link,
//           from: "FirebaseDynamicLinks onLink received on starting/app open.",
//         ),
//       );
//       final Uri deepLink = initialLink.link;
//       initialRoute = containsSpecificPath(deepLink);
//       slug = extractLastPathComponent(deepLink);
//       log(
//         "Initial link Received ** => ${"\n\n"}${deepLink.path}${"\n"}$deepLink${"\n"}${deepLink.path.contains("/install")}${"\n"}${deepLink.hasQuery}${"\n"}${deepLink.origin}${"\n"}${"\n\n"}",
//       );
//       if (deepLink.path.contains("page.link") ||
//           deepLink.path.contains("/install") ||
//           deepLink.path.contains("?code=") ||
//           deepLink.path.contains("?referrer=") ||
//           deepLink.path.contains("?ref=") ||
//           deepLink.path.contains("?referral_code=")) {
//         String? referralCode = deepLink.queryParameters['code'];
//         if (referralCode == null || referralCode == '') {
//           referralCode = deepLink.queryParameters['referrer'];
//         }
//         if (referralCode == null || referralCode == '') {
//           referralCode = deepLink.queryParameters['ref'];
//         }
//         if (referralCode == null || referralCode == '') {
//           referralCode = deepLink.queryParameters['referral_code'];
//         }
//         bool isFirstOpen = await Preference.isFirstOpen();
//         String? code = await Preference.getReferral();
//         if (referralCode != null &&
//             referralCode != "" &&
//             code == null &&
//             isFirstOpen) {
//           log("CODE HERE @@@++++=========>  $referralCode");
//           Preference.saveReferral(referralCode);
//           Timer(const Duration(seconds: 4), () {
//             if (navigatorKey.currentContext!.read<UserProvider>().user ==
//                 null) {
//               signupSheet();
//               // onDeepLinking = false;
//               Timer(const Duration(seconds: 3), () {
//                 onDeepLinking = false;
//               });
//             }
//           });
//           FirebaseAnalytics.instance.logEvent(
//             name: 'referrals',
//             parameters: {'referral_code': referralCode},
//           );
//         }
//       }
//       // navigateDeepLinks(uri: deepLink);
//     }
//   }
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     isAppInForeground = state == AppLifecycleState.resumed;
//     // Utils().showLog("**** is in foreground ==>  $isAppInForeground");
//     setState(() {
//       _appLifecycleState = state;
//     });
//   }
//   void _getAppLinks() async {
//     // --------- initially ---------–
//     // try {
//     //   if ((await Preference.getReferral()) == null) {
//     //     Uri? initialLink = await _appLinks.getInitialLink();
//     //     Preference.saveDataList(
//     //       DeeplinkData(
//     //         uri: initialLink,
//     //         from: "AppLinks getInitialLink on starting/app open.",
//     //       ),
//     //     );
//     //     if (initialLink != null) {
//     //       String? referralCode = initialLink.queryParameters['referrer'] ??
//     //           initialLink.queryParameters['ref'] ??
//     //           initialLink.queryParameters['referral_code'];
//     //       if (referralCode != null && referralCode != "") {
//     //         Preference.saveReferral(referralCode);
//     //       }
//     //     }
//     //   }
//     // } catch (e) {
//     //   print('Error Receiving referral $e');
//     // }
// // --------- Listen ----------
//     _appLinks.uriLinkStream.listen((event) {
//       Preference.saveDataList(
//         DeeplinkData(
//           uri: event,
//           from: "AppLinks listened on _appLinks.uriLinkStream.listen",
//         ),
//       );
//       bool isRef = event.toString().contains("/install") ||
//           event.toString().contains(".page.link") ||
//           event.toString().contains("app.stocks.news://");
//       if (isRef) {
//         return;
//       }
//       if (onDeepLinking == true) return;
//       onDeepLinking = true;
//       String type = containsSpecificPath(event);
//       String slug = extractLastPathComponent(event);
//       if (_appLifecycleState == null) {
//         Timer(const Duration(seconds: 4), () {
//           navigation(
//             uri: event,
//             slug: slug,
//             type: type,
//             fromBackground: false,
//             from: "_appLinks.uriLinkStream.listen BACKGROUND condition",
//           );
//           // onDeepLinking = false;
//           Timer(const Duration(seconds: 3), () {
//             onDeepLinking = false;
//           });
//         });
//       } else {
//         Timer(const Duration(seconds: 1), () {
//           navigation(
//             uri: event,
//             slug: slug,
//             type: type,
//             from: "_appLinks.uriLinkStream.listen NORMAL Condition",
//           );
//         });
//       }
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return MultiProvider(
          providers: Routes.providers,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: Const.appName,
            theme: lightTheme,
            home: child,
            // home: widget.initialUri != null
            //     ? findInitialWidget(uri: widget.initialUri!)
            //     : child,
            routes: Routes.routes,
            // onGenerateRoute: Routes.getRouteGenerate,
          ),
        );
      },
      child: const Splash(),
      // child: const SignUpSuccess(),
    );
  }
}
