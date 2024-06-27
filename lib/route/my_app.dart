// ignore_for_file: unused_element

import 'dart:async';

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
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
// import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

final _appLinks = AppLinks();
//
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({this.initialUri, super.key});
  final Uri? initialUri;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialDeepLinks = false;

  @override
  void dispose() {
    super.dispose();
  }

  bool connection = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getInitialReferralsIfAny();
      getInitialDeeplinkWhenAppOpen();
      startListeningForDeepLinks();
    });
  }

  void getInitialReferralsIfAny() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    Utils().showLog(" FirebaseDynamicLinks.instance.getInitialLink CALLED");

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      if (deepLink.path.contains("page.link") ||
          deepLink.path.contains("/install") ||
          deepLink.path.contains("?code=") ||
          deepLink.path.contains("?referrer=") ||
          deepLink.path.contains("?ref=") ||
          deepLink.path.contains("?referral_code=")) {
        _initialDeepLinks = true;
        await _handleReferralLink(deepLink);
        Timer(const Duration(seconds: 2), () {
          _initialDeepLinks = false;
        });
      }
    }

    // FirebaseDynamicLinks.instance.onLink.listen(
    //   (pendingDynamicLinkData) {
    //     if (pendingDynamicLinkData != null) {
    //       final Uri deepLink = pendingDynamicLinkData.link;
    //       // if (deepLink != null) {
    //       if (deepLink.path.contains("page.link") ||
    //           deepLink.path.contains("/install") ||
    //           deepLink.path.contains("?code=") ||
    //           deepLink.path.contains("?referrer=") ||
    //           deepLink.path.contains("?ref=") ||
    //           deepLink.path.contains("?referral_code=")) {
    //         _initialDeepLinks = true;
    //         _handleReferralLink(deepLink);
    //         Timer(const Duration(seconds: 2), () {
    //           _initialDeepLinks = false;
    //         });
    //       }
    //     }
    //   },
    // );
  }

  Future<void> _handleReferralLink(Uri deepLink) async {
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

    Utils().showLog(
        "referralCode = $referralCode && referralCode = $referralCode && code = $code && isFirstOpen = $isFirstOpen");

    // popUpAlert(
    //   message:
    //       "referralCode = $referralCode && referralCode = $referralCode && code = $code && isFirstOpen = $isFirstOpen",
    //   title: "title",
    // );

    if (referralCode != null &&
        referralCode != "" &&
        code == null &&
        isFirstOpen) {
      Preference.saveReferral(referralCode);
      // Preference.setIsFirstOpen(false);
      Timer(const Duration(seconds: 4), () {
        if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
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
  // -------- Initial Deeplinks For Referral Ended ---------------

  // -------- Initial Deeplinks when App Opened Started ---------------
  void getInitialDeeplinkWhenAppOpen() async {
    Uri? initialUri = await _appLinks.getInitialLink();
    Utils().showLog(" _appLinks.getInitialLink CALLED");

    // if (initialUri != null) {
    //   popUpAlert(
    //     message: "GetInitialDeeplinkWhenAppOpen = $initialUri ",
    //     title: "title",
    //   );
    // }

    if (initialUri != null) {
      final Uri deepLink = initialUri;
      if (deepLink.path.contains("page.link") ||
          deepLink.path.contains("/install") ||
          deepLink.path.contains("?code=") ||
          deepLink.path.contains("?referrer=") ||
          deepLink.path.contains("?ref=") ||
          deepLink.path.contains("?referral_code=")) {
        // onDeepLinking = true;
        await _handleReferralLink(deepLink);
        return;
      }
    }

    if (initialUri != null) {
      DeeplinkEnum type = containsSpecificPath(initialUri);
      _initialDeepLinks = true;
      // onDeepLinking = (type == "login" || type == "signUp") ? false : true;
      onDeepLinking =
          (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
              ? false
              : true;
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

      if (onDeepLinking || _initialDeepLinks) return;

      DeeplinkEnum type = containsSpecificPath(event);
      // onDeepLinking = (type == "login" || type == "signUp") ? false : true;
      onDeepLinking =
          (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
              ? false
              : true;
      handleDeepLinkNavigation(uri: event);
    });
  }
  // -------- Listen for incoming deeplinks Ended ---------------

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
            routes: Routes.routes,
          ),
        );
      },
      child: const Splash(),
    );
  }
}
