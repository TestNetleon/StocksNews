import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:country_code_picker/country_code_picker.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/fcm/braze_notification_handler.dart';
import 'package:stocks_news_new/fcm/braze_service.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/navigation_observer.dart';
import 'package:stocks_news_new/routes/routes.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/socket/socket.dart';
import 'package:stocks_news_new/ui/subscription/service.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../ui/onboarding/splash.dart';

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
  // bool _initialDeepLinks = false;
  bool connection = true;
  static const deeplinkPlatform = MethodChannel('deepLinkChannel');
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pingApi(SocketEnum.open);

      // getInitialReferralsIfAny();
      // getInitialDeeplinkWhenAppOpen();
      // startListeningForDeepLinks();

      // oneSignalInitialized = true;
      listenForPushToken();
      NotificationHandler.instance.setupNotificationListeners();
      // brazeDeepLink();
      _configureSubscriptionService();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Future _configureSubscriptionService() async {
    UserRes? userRes = await Preference.getUser();
    SubscriptionService.instance.initialize(user: userRes);
  }

  brazeDeepLink() {
    deeplinkPlatform.setMethodCallHandler((call) async {
      if (call.method == 'receiveDeepLink') {
        try {
          Utils().showLog('got deep link ${call.arguments}');
          final Uri deepLink = Uri.parse(call.arguments);
          DeeplinkEnum type = containsSpecificPath(deepLink);
          Utils().showLog('type link $type');
          handleDeepLinkNavigation(uri: deepLink);
        } catch (e) {
          Utils().showLog('error $e');
        }
      }
    });
  }

  Future<void> listenForPushToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    String? deviceToken = await messaging.getAPNSToken();
    String? fcmToken;

    await messaging.getToken().then((value) async {
      if (value != null) {
        fcmToken = value;
        if (Platform.isAndroid) {
          BrazeService().registerFCM(fcmToken);
        } else {
          // BrazeService().registerFCM(deviceToken);
        }
        Utils().showLog("FCM Token: $fcmToken");
        Utils().showLog("DEVICE Token: $deviceToken");
      }
    });

    String? address = await BrazeNotificationService.instance.getUserLocation();
    UserRes? user = await Preference.getUser();
    Preference.saveFcmToken(fcmToken);
    Preference.saveLocation(address);
    if (user == null) {
      Timer(
        Duration(seconds: 15),
        () async {
          BrazeNotificationService.instance.getTemUser(value: fcmToken);
        },
      );
    }
    // await Preference.setAmplitudeFirstOpen(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isAppInForeground = state == AppLifecycleState.resumed;
    if (state == AppLifecycleState.resumed) {
      pingApi(SocketEnum.active);
    }
  }

  @override
  void didChangePlatformBrightness() {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    ThemeManager manager = navigatorKey.currentContext!.read<ThemeManager>();
    bool isDark = brightness == Brightness.dark;
    if (manager.themeMode == ThemeMode.system) {
      manager.toggleTheme(isDark ? ThemeMode.dark : ThemeMode.light);
      manager.toggleTheme(ThemeMode.system);
    }
  }

  // -------- Initial Deeplinks For Referral STARTED ---------------
  // void getInitialReferralsIfAny() async {
  //   try {
  //     final PendingDynamicLinkData? initialLink =
  //         await FirebaseDynamicLinks.instance.getInitialLink();
  //     Utils().showLog(" FirebaseDynamicLinks.instance.getInitialLink CALLED");
  //     if (initialLink != null) {
  //       final Uri deepLink = initialLink.link;

  //       extractCodeFromMEM(deepLink, "1");
  //       Utils().showLog("MEM CODE get initial referrals => $memCODE");

  //       if (deepLink.path.contains("page.link") ||
  //           deepLink.path.contains("/install") ||
  //           deepLink.path.contains("?code=") ||
  //           deepLink.path.contains("?referrer=") ||
  //           deepLink.path.contains("?ref=") ||
  //           deepLink.path.contains("?referral_code=")) {
  //         _initialDeepLinks = true;
  //         await _handleReferralLink(deepLink);
  //         Timer(const Duration(seconds: 2), () {
  //           _initialDeepLinks = false;
  //         });
  //       } else {
  //         // if (deepLink.path.contains('MEM')) {
  //         //   memTrack = true;
  //         // }
  //       }
  //     } else {
  //       // bool isFirstOpen = await Preference.isFirstOpen();
  //       // if (isFirstOpen) {
  //       //   Timer(const Duration(seconds: 8), () {
  //       //     if (navigatorKey.currentContext!.read<UserProvider>().user ==
  //       //             null &&
  //       //         !signUpVisible) {
  //       //       // signupSheet();
  //       //       loginFirstSheet();
  //       //     }
  //       //   });
  //       // }
  //     }

  //     FirebaseDynamicLinks.instance.onLink.listen(
  //       (pendingDynamicLinkData) {
  //         if (!_initialDeepLinks) {
  //           final Uri deepLink = pendingDynamicLinkData.link;
  //           extractCodeFromMEM(deepLink, "2");
  //           Utils().showLog("MEM CODE get initial referrals 1=> $memCODE");
  //           // if (deepLink != null) {
  //           if (deepLink.path.contains("page.link") ||
  //               deepLink.path.contains("/install") ||
  //               deepLink.path.contains("?code=") ||
  //               deepLink.path.contains("?referrer=") ||
  //               deepLink.path.contains("?ref=") ||
  //               deepLink.path.contains("?referral_code=")) {
  //             _initialDeepLinks = true;
  //             _handleReferralLink(deepLink);
  //             Timer(const Duration(seconds: 2), () {
  //               _initialDeepLinks = false;
  //             });
  //           } else {
  //             // if (deepLink.path.contains('MEM')) {
  //             //   memTrack = true;
  //             // }
  //           }
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     //
  //   }
  // }

  // Future<void> _handleReferralLink(Uri deepLink) async {
  //   try {
  //     // Preference.saveDataList(
  //     //   DeeplinkData(
  //     //     from: "** _handleReferralLink " "\n" " ${deepLink.toString()} ",
  //     //   ),
  //     // );

  //     String? referralCode = deepLink.queryParameters['code'];
  //     if (referralCode == null || referralCode == '') {
  //       referralCode = deepLink.queryParameters['referrer'];
  //     }
  //     if (referralCode == null || referralCode == '') {
  //       referralCode = deepLink.queryParameters['ref'];
  //     }
  //     if (referralCode == null || referralCode == '') {
  //       referralCode = deepLink.queryParameters['referral_code'];
  //     }

  //     bool isFirstOpen = await Preference.isFirstOpen();
  //     String? code = await Preference.getReferral();

  //     Utils().showLog("referralCode = $referralCode && "
  //         "\n"
  //         " code = $code &&  "
  //         "\n"
  //         " isFirstOpen = $isFirstOpen  "
  //         "\n"
  //         " deepLink = $deepLink");

  //     if (referralCode != null &&
  //         referralCode != "" &&
  //         code == null &&
  //         isFirstOpen) {
  //       Preference.saveReferral(referralCode);
  //       Timer(const Duration(seconds: 4), () {
  //         UserManager manager =
  //             navigatorKey.currentContext!.read<UserManager>();

  //         if (manager.user == null && !signUpVisible) {
  //           manager.askLoginScreen();
  //         }
  //       });
  //       FirebaseAnalytics.instance.logEvent(
  //         name: 'referrals',
  //         parameters: {'referral_code': referralCode},
  //       );
  //     }
  //     onDeepLinking = false;
  //   } catch (e) {
  //     //
  //   }
  // }
  // // -------- Initial Deeplinks For Referral Ended ---------------

  // // -------- Initial Deeplinks when App Opened Started ---------------
  // void getInitialDeeplinkWhenAppOpen() async {
  //   try {
  //     Uri? initialUri = await _appLinks.getInitialLink();
  //     Utils().showLog(" _appLinks.getInitialLink CALLED");

  //     if (initialUri != null) {
  //       final Uri deepLink = initialUri;
  //       extractCodeFromMEM(deepLink, "3");
  //       Utils().showLog("MEM CODE get initial deep link => $memCODE");
  //       if (deepLink.path.contains("page.link") ||
  //           deepLink.path.contains("/install") ||
  //           deepLink.path.contains("?code=") ||
  //           deepLink.path.contains("?referrer=") ||
  //           deepLink.path.contains("?ref=") ||
  //           deepLink.path.contains("?referral_code=")) {
  //         // onDeepLinking = true;
  //         await _handleReferralLink(deepLink);
  //         return;
  //       } else {
  //         // if (deepLink.path.contains('MEM')) {
  //         //   memTrack = true;
  //         // }
  //       }
  //     }

  //     if (initialUri != null) {
  //       final Uri deepLink = initialUri;
  //       DeeplinkEnum type = containsSpecificPath(initialUri);
  //       _initialDeepLinks = true;
  //       onDeepLinking =
  //           (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
  //               ? false
  //               : true;

  //       if (deepLink.path.contains("MEM")) {
  //         onDeepLinking = false;
  //       }
  //       // popUpAlert(
  //       //     message:
  //       //         "2nd FUNCTION going for navigation: $onDeepLinking, $type, $popHome");
  //       handleDeepLinkNavigation(uri: initialUri, duration: 5);
  //       Timer(const Duration(milliseconds: 200), () {
  //         _initialDeepLinks = false;
  //       });
  //     }
  //   } catch (e) {
  //     //
  //   }
  // }
  // // -------- Initial Deeplinks when App Opened Ended ---------------

  // // -------- Listen for incoming deeplinks Started ---------------
  // void startListeningForDeepLinks() {
  //   try {
  //     _appLinks.uriLinkStream.listen((event) async {
  //       if (onDeepLinking || _initialDeepLinks) return;

  //       final Uri deepLink = event;
  //       if (deepLink.path.contains("page.link") ||
  //           deepLink.path.contains("/install") ||
  //           deepLink.path.contains("?code=") ||
  //           deepLink.path.contains("?referrer=") ||
  //           deepLink.path.contains("?ref=") ||
  //           deepLink.path.contains("?referral_code=")) {
  //         await _handleReferralLink(deepLink);
  //         return;
  //       }
  //       if (event.toString().contains("com.googleusercontent.apps") ||
  //           event.toString().contains("app.stocks.news://google/link")) {
  //         return;
  //       }

  //       DeeplinkEnum type = containsSpecificPath(event);

  //       onDeepLinking =
  //           (type == DeeplinkEnum.login || type == DeeplinkEnum.signup)
  //               ? false
  //               : true;
  //       if (deepLink.path.contains("MEM")) {
  //         onDeepLinking = false;
  //       }
  //       // popUpAlert(
  //       //     message:
  //       //         "3rd FUNCTION going for navigation: $onDeepLinking, $type, $popHome, ${deepLink.path}, $deepLink");
  //       handleDeepLinkNavigation(uri: event);
  //     });
  //   } catch (e) {
  //     //
  //   }
  // }
  // // -------- Listen for incoming deeplinks Ended ---------------

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return MultiProvider(
          providers: Routes.providers,
          child: Consumer<ThemeManager>(
            builder: (context, value, child) {
              return MaterialApp(
                // initialRoute: '/',
                supportedLocales: const [Locale("en")],
                localizationsDelegates: const [CountryLocalizations.delegate],
                navigatorObservers: [CustomNavigatorObserver()],
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: Const.appName,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: value.themeMode,
                home: child,
                routes: Routes.routes,
                onGenerateRoute: Routes.getRouteGenerate,
              );
            },
          ),
        );
      },
      child: const Splash(),
      // child: Scaffold(),
    );
  }
}
