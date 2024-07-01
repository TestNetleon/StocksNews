// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/dummy.dart';
import 'package:stocks_news_new/route/routes.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
// import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

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
  static const platform = MethodChannel('app.stocks.new/dynamic_link');

  @override
  void dispose() {
    super.dispose();
  }

  bool connection = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Platform.isIOS) {
        _handleIOSDeeplinks();
        // _handleBranchIOSDeeplinks();
      }
      getInitialReferralsIfAny();
      getInitialDeeplinkWhenAppOpen();
      startListeningForDeepLinks();
    });
  }

// -------- Branch.io Deeplinks STARTED ---------------
  // void _handleBranchIOSDeeplinks() async {
  //   try {
  //     await FlutterBranchSdk.init(
  //       disableTracking: false,
  //       enableLogging: true,
  //       useTestKey: true,
  //     );
  //     FlutterBranchSdk.validateSDKIntegration();
  //     // StreamSubscription<Map> streamSubscription =
  //     FlutterBranchSdk.listSession().listen((data) {
  //       log("FlutterBranchSdk.listSession = ${data.toString()} ");
  //       if (data.containsKey("+clicked_branch_link") &&
  //           data["+clicked_branch_link"] == true) {
  //         //Link clicked. Add logic to get link data and route user to correct screen
  //         print('Custom string: ${data["custom_string"]}');
  //       }
  //     }, onError: (error) {
  //       PlatformException platformException = error as PlatformException;
  //       print(
  //         'InitSession error: ${platformException.code} - ${platformException.message}',
  //       );
  //     });
  //   } catch (e) {
  //     print('Error initializing Branch SDK: $e');
  //   }
  // }
// -------- Branch.io Deeplinks ENDED ---------------

// -------- IOS Native Deeplinks STARTED ---------------
  void _handleIOSDeeplinks() async {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onDynamicLink') {
        String? link = call.arguments['link'];
        // Handle the dynamic link in Flutter
        // print('Received dynamic link: $link');
        // Preference.saveDataList(
        //   DeeplinkData(
        //     from: "platform.setMethodCallHandler _handleIOSDeeplinks",
        //   ),
        // );

        if (link != null) {
          onDeepLinking = true;
          _handleReferralLink(Uri.parse(link));
        }
      }
    });

    final String? initialLink = await platform.invokeMethod('getInitialLink');
    if (initialLink != null) {
      print('Initial dynamic link: $initialLink');
      DeeplinkEnum type = containsSpecificPath(Uri.parse(initialLink));
      // onDeepLinking = (type == "login" || type == "signUp") ? false : true;
      onDeepLinking =
          (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
              ? false
              : true;

      // Preference.saveDataList(
      //   DeeplinkData(
      //     from: "platform.setMethodCallHandler getInitialLink",
      //   ),
      // );
      handleDeepLinkNavigation(uri: Uri.parse(initialLink));
    }
  }
// -------- Initial Deeplinks ENDED ---------------

// -------- Initial Deeplinks For Referral STARTED ---------------
  void getInitialReferralsIfAny() async {
    // if (Platform.isIOS) {
    //   platform.setMethodCallHandler((MethodCall call) async {
    //     if (call.method == 'onDynamicLink') {
    //       String? link = call.arguments['link'];
    //       // Handle the dynamic link in Flutter
    //       // print('Received dynamic link: $link');
    //       if (link != null) {
    //               Preference.saveDataList(
    //     DeeplinkData(
    //       from: "platform.setMethodCallHandler getInitialLink",
    //     ),
    //   );
    //         _handleReferralLink(Uri.parse(link));
    //       }
    //     }
    //   });

    //   final String? initialLink = await platform.invokeMethod('getInitialLink');
    //   if (initialLink != null) {
    //     print('Initial dynamic link: $initialLink');
    //     DeeplinkEnum type = containsSpecificPath(Uri.parse(initialLink));
    //     // onDeepLinking = (type == "login" || type == "signUp") ? false : true;
    //     onDeepLinking =
    //         (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
    //             ? false
    //             : true;
    //     handleDeepLinkNavigation(uri: Uri.parse(initialLink));
    //   }

    //   return;
    // }

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

    Utils().showLog(
        "referralCode = $referralCode && referralCode = $referralCode && code = $code && isFirstOpen = $isFirstOpen");
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
      // Preference.saveDataList(
      //   DeeplinkData(
      //     from: "** getInitialLink " "\n" " ${initialUri.toString()}",
      //   ),
      // );
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
      // if (event.toString().contains("app.stocks.news://")) return;

      Utils().showLog(
          " startListeningForDeepLinks CALLED $event $onDeepLinking $_initialDeepLinks");

      if (onDeepLinking || _initialDeepLinks) return;

      final Uri deepLink = event;
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

      DeeplinkEnum type = containsSpecificPath(event);
      // onDeepLinking = (type == "login" || type == "signUp") ? false : true;
      onDeepLinking =
          (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
              ? false
              : true;

      // Preference.saveDataList(
      //   DeeplinkData(
      //     from: "** startListeningForDeepLinks " "\n" " ${event.toString()} ",
      //   ),
      // );

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
            // onGenerateRoute: Routes.getRouteGenerate,
          ),
        );
      },
      child: const Splash(),
    );
  }
}
