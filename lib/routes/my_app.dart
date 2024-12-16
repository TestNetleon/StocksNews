import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:braze_plugin/braze_plugin.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/fcm/braze_service.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/navigation_observer.dart';
import 'package:stocks_news_new/routes/routes.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../api/apis.dart';
import '../screens/auth/base/base_auth.dart';

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
  static const platform = MethodChannel('brazeMethod');
  static final BrazePlugin _braze = BrazePlugin(
    customConfigs: {replayCallbacksConfigKey: true},
    brazeSdkAuthenticationErrorHandler: (e) {
      print('authentication error : $e ');
    },
  );
  static StreamSubscription? pushEventsStreamSubscription;

  final StreamController<BrazePushEvent> pushEventStreamController =
      StreamController<BrazePushEvent>.broadcast();

  bool _initialDeepLinks = false;
  bool connection = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      oneSignalInitialized = true;
      listenForPushToken();
      listenForNotification();
      configureRevenueCatAttribute();
      getInitialReferralsIfAny();
      getInitialDeeplinkWhenAppOpen();
      startListeningForDeepLinks();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> listenForPushToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (Platform.isAndroid) {
      await messaging.requestPermission();
    }
    String? deviceToken = await messaging.getAPNSToken();
    String? fcmToken;
    if (deviceToken != null && Platform.isIOS) {
      await messaging.getToken().then((value) async {
        if (value != null) {
          fcmToken = value;
          Utils().showLog("FCM Token registered with Braze: $fcmToken");
        }
      });
    } else {
      if (Platform.isAndroid) {
        await messaging.getToken().then((value) async {
          if (value != null) {
            fcmToken = value;
            BrazeService().registerFCM(fcmToken);
            Utils().showLog("FCM Token registered with Braze: $fcmToken");
          }
        });
      }
    }
    String? address = await BrazeNotificationService().getUserLocation();
    BrazeNotificationService().saveFCMApi(value: fcmToken, address: address);
  }

  void listenForNotification() {
    if (Platform.isIOS) {
      try {
        platform.setMethodCallHandler((call) async {
          popHome = true;
          if (call.method == 'onBrazeNotificationReceived') {
            final title = call.arguments['title'];
            final body = call.arguments['body'];
            final userInfo = call.arguments['userInfo'];
            Utils().showLog(
                'Notification received: title=$title, body=$body, userInfo=$userInfo');
          } else if (call.method == 'onBrazeNotificationOpened') {
            final userInfo = call.arguments['userInfo'];
            BrazeNotificationService().navigateToRequiredScreen(userInfo);
          }
        });
      } catch (e) {
        Utils().showLog('iOS notification error: $e');
      }
    } else {
      try {
        pushEventsStreamSubscription = _braze
            .subscribeToPushNotificationEvents((BrazePushEvent pushEvent) {
          popHome = true;
          if (pushEvent.payloadType == 'push_opened') {
            BrazeNotificationService()
                .navigateToRequiredScreen(pushEvent.brazeProperties);
          }
        });
      } catch (e) {
        Utils().showLog('Android notification error: $e');
      }
    }
  }

  listenForInAppMessage() {
    _braze.subscribeToInAppMessages(
      (BrazeInAppMessage event) {},
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pushEventsStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isAppInForeground = state == AppLifecycleState.resumed;
  }

  // -------- Initial Deeplinks For Referral STARTED ---------------
  void getInitialReferralsIfAny() async {
    try {
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      Utils().showLog(" FirebaseDynamicLinks.instance.getInitialLink CALLED");
      if (initialLink != null) {
        final Uri deepLink = initialLink.link;

        extractCodeFromMEM(deepLink, "1");
        Utils().showLog("MEM CODE get initial referrals => $memCODE");

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
        } else {
          // if (deepLink.path.contains('MEM')) {
          //   memTrack = true;
          // }
        }
      } else {
        bool isFirstOpen = await Preference.isFirstOpen();
        if (isFirstOpen) {
          Timer(const Duration(seconds: 8), () {
            if (navigatorKey.currentContext!.read<UserProvider>().user ==
                    null &&
                !signUpVisible) {
              // signupSheet();
              loginFirstSheet();
            }
          });
        }
      }

      FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
          if (!_initialDeepLinks) {
            final Uri deepLink = pendingDynamicLinkData.link;
            extractCodeFromMEM(deepLink, "2");
            Utils().showLog("MEM CODE get initial referrals 1=> $memCODE");
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
            } else {
              // if (deepLink.path.contains('MEM')) {
              //   memTrack = true;
              // }
            }
          }
        },
      );
    } catch (e) {
      //
    }
  }

  Future<void> _handleReferralLink(Uri deepLink) async {
    try {
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
          if (navigatorKey.currentContext!.read<UserProvider>().user == null &&
              !signUpVisible) {
            // signupSheet();
            loginFirstSheet();
          }
        });
        FirebaseAnalytics.instance.logEvent(
          name: 'referrals',
          parameters: {'referral_code': referralCode},
        );
      }
      onDeepLinking = false;
    } catch (e) {
      //
    }
  }
  // -------- Initial Deeplinks For Referral Ended ---------------

  // -------- Initial Deeplinks when App Opened Started ---------------
  void getInitialDeeplinkWhenAppOpen() async {
    try {
      Uri? initialUri = await _appLinks.getInitialLink();
      Utils().showLog(" _appLinks.getInitialLink CALLED");

      if (initialUri != null) {
        final Uri deepLink = initialUri;
        extractCodeFromMEM(deepLink, "3");
        Utils().showLog("MEM CODE get initial deep link => $memCODE");
        if (deepLink.path.contains("page.link") ||
            deepLink.path.contains("/install") ||
            deepLink.path.contains("?code=") ||
            deepLink.path.contains("?referrer=") ||
            deepLink.path.contains("?ref=") ||
            deepLink.path.contains("?referral_code=")) {
          // onDeepLinking = true;
          await _handleReferralLink(deepLink);
          return;
        } else {
          // if (deepLink.path.contains('MEM')) {
          //   memTrack = true;
          // }
        }
      }

      if (initialUri != null) {
        final Uri deepLink = initialUri;
        DeeplinkEnum type = containsSpecificPath(initialUri);
        _initialDeepLinks = true;
        onDeepLinking =
            (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
                ? false
                : true;

        if (deepLink.path.contains("MEM")) {
          onDeepLinking = false;
        }
        // popUpAlert(
        //     message:
        //         "2nd FUNCTION going for navigation: $onDeepLinking, $type, $popHome");
        handleDeepLinkNavigation(uri: initialUri, duration: 5);
        Timer(const Duration(milliseconds: 200), () {
          _initialDeepLinks = false;
        });
      }
    } catch (e) {
      //
    }
  }
  // -------- Initial Deeplinks when App Opened Ended ---------------

  // -------- Listen for incoming deeplinks Started ---------------
  void startListeningForDeepLinks() {
    try {
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
        if (event.toString().contains("com.googleusercontent.apps") ||
            event.toString().contains("app.stocks.news://google/link")) {
          return;
        }

        DeeplinkEnum type = containsSpecificPath(event);

        onDeepLinking =
            (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
                ? false
                : true;
        if (deepLink.path.contains("MEM")) {
          onDeepLinking = false;
        }
        // popUpAlert(
        //     message:
        //         "3rd FUNCTION going for navigation: $onDeepLinking, $type, $popHome, ${deepLink.path}, $deepLink");
        handleDeepLinkNavigation(uri: event);
      });
    } catch (e) {
      //
    }
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

Future<void> configureRevenueCatAttribute() async {
  try {
    UserRes? user = await Preference.getUser();
    String? appUserId = user?.userId;

    // Set the API keys based on the platform
    String apiKey = Platform.isAndroid ? ApiKeys.androidKey : ApiKeys.iosKey;

    // Configure Purchases
    PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
    if (appUserId != null) {
      configuration.appUserID = appUserId;
    }

    await Purchases.configure(configuration);

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String? firebaseAppInstanceId = await analytics.appInstanceId;
    if (firebaseAppInstanceId != null && firebaseAppInstanceId != '') {
      Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
      Utils().showLog('Set app instance ID => $firebaseAppInstanceId');
    }
    try {
      final _appsFlyerService = AppsFlyerService(
        ApiKeys.appsFlyerKey,
        ApiKeys.iosAppID,
      );
      AppsFlyerService(
        ApiKeys.appsFlyerKey,
        ApiKeys.iosAppID,
      ).appsflyerDeepLink();

      _appsFlyerService.appsflyerDeepLink();
    } catch (e) {
      //
    }
    if (Platform.isIOS) {
      await Purchases.enableAdServicesAttributionTokenCollection();
    }
  } catch (e) {
    Utils().showLog("Error in configure RevenueCat: $e");
  }
}
