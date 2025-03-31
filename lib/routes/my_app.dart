import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:country_code_picker/country_code_picker.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
