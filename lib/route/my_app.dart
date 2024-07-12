// ignore_for_file: unused_element

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/navigation_observer.dart';
// import 'package:stocks_news_new/dummy.dart';
import 'package:stocks_news_new/route/routes.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
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

class _MyAppState extends State<MyApp> {
  bool _initialDeepLinks = false;

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

// -------- Initial Deeplinks For Referral STARTED ---------------
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
    } else {
      bool isFirstOpen = await Preference.isFirstOpen();
      if (isFirstOpen) {
        Timer(const Duration(seconds: 5), () {
          if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
            signupSheet();
          }
        });
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) {
        if (!_initialDeepLinks) {
          final Uri deepLink = pendingDynamicLinkData.link;
          // if (deepLink != null) {
          if (deepLink.path.contains("page.link") ||
              deepLink.path.contains("/install") ||
              deepLink.path.contains("?code=") ||
              deepLink.path.contains("?referrer=") ||
              deepLink.path.contains("?ref=") ||
              deepLink.path.contains("?referral_code=")) {
            _initialDeepLinks = true;
            _handleReferralLink(deepLink);
            Timer(const Duration(seconds: 2), () {
              _initialDeepLinks = false;
            });
          }
        }
      },
    );
  }

  Future<void> _handleReferralLink(Uri deepLink) async {
    // Preference.saveDataList(
    //   DeeplinkData(
    //     from: "** _handleReferralLink " "\n" " ${deepLink.toString()} ",
    //   ),
    // );

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

    // popUpAlert(message: "Referral code = $referralCode", title: "RECEIVED");
    bool isFirstOpen = await Preference.isFirstOpen();
    String? code = await Preference.getReferral();

    Utils().showLog("referralCode = $referralCode && "
        "\n"
        " code = $code &&  "
        "\n"
        " isFirstOpen = $isFirstOpen  "
        "\n"
        " deepLink = $deepLink");

    if (referralCode != null &&
        referralCode != "" &&
        code == null &&
        isFirstOpen) {
      Preference.saveReferral(referralCode);
      Timer(const Duration(seconds: 4), () {
        if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
          signupSheet();
        }
      });
      FirebaseAnalytics.instance.logEvent(
        name: 'referrals',
        parameters: {'referral_code': referralCode},
      );
    }
    onDeepLinking = false;
  }
  // -------- Initial Deeplinks For Referral Ended ---------------

  // -------- Initial Deeplinks when App Opened Started ---------------
  void getInitialDeeplinkWhenAppOpen() async {
    Uri? initialUri = await _appLinks.getInitialLink();
    Utils().showLog(" _appLinks.getInitialLink CALLED");

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
      onDeepLinking =
          (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
              ? false
              : true;
      handleDeepLinkNavigation(uri: initialUri);
      Timer(const Duration(milliseconds: 200), () {
        _initialDeepLinks = false;
      });
    }
  }
  // -------- Initial Deeplinks when App Opened Ended ---------------

  // -------- Listen for incoming deeplinks Started ---------------
  void startListeningForDeepLinks() {
    _appLinks.uriLinkStream.listen((event) async {
      if (onDeepLinking || _initialDeepLinks) return;

      final Uri deepLink = event;
      if (deepLink.path.contains("page.link") ||
          deepLink.path.contains("/install") ||
          deepLink.path.contains("?code=") ||
          deepLink.path.contains("?referrer=") ||
          deepLink.path.contains("?ref=") ||
          deepLink.path.contains("?referral_code=")) {
        await _handleReferralLink(deepLink);
        return;
      }
      if (event.toString().contains("com.googleusercontent.apps")) {
        return;
      }

      DeeplinkEnum type = containsSpecificPath(event);
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
            supportedLocales: const [Locale("en")],
            localizationsDelegates: const [CountryLocalizations.delegate],
            navigatorObservers: [CustomNavigatorObserver()],
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: Const.appName,
            theme: lightTheme,
            home: child,
            routes: Routes.routes,
            // onGenerateRoute: Routes.getRouteGenerate,
          ),
        );
      },
      child: const Splash(),
    );
  }
}
