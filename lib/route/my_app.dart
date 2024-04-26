// ignore_for_file: unused_element

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/routes.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  bool connection = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _handleIncomingLinks();
      // _handleInitialUri();

      Timer(const Duration(milliseconds: 7200), () {
        _checkForConnection();
      });
      setState(() {});
    });
  }

  void _checkForConnection() async {
    // final connectivityResult = await (Connectivity().checkConnectivity());

    // if (connectivityResult == ConnectivityResult.none) {
    //   connection = false;
    //   Navigator.push(navigatorKey.currentContext!,
    //       MaterialPageRoute(builder: (_) => const InternetConnectionWidget()));
    //   showErrorMessage(message: "No internet connection ");
    // }

    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.mobile ||
    //       result == ConnectivityResult.wifi) {
    //     log("connection");
    //     if (!connection) {
    //       Navigator.pop(navigatorKey.currentContext!);
    //     }
    //     connection = true;
    //   } else {
    //     log("withoutConnection");
    //     connection = false;
    //     Navigator.push(
    //         navigatorKey.currentContext!,
    //         MaterialPageRoute(
    //             builder: (_) => const InternetConnectionWidget()));
    //     showErrorMessage(message: "No internet connection ");
    //   }
    // });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    try {
      if (!kIsWeb) {
        log('entered incoming links');
        _sub = uriLinkStream.listen((Uri? uri) {
          // if (!mounted) return;

          if (uri == null) {
            log("found no incoming links");
          } else {
            log('found URI in incoming links : $uri');

            // Navigator.push(
            //   navigatorKey.currentContext!,
            //   MaterialPageRoute(
            //     builder: (context) => WebviewLink(url: uri.toString()),
            //   ),
            // );

            _navigate(uri);
          }
        }, onError: (Object err) {
          log('got err: $err');
        });
      }
    } catch (e) {
      log("ERROR $e");
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    try {
      Uri? uri = await getInitialUri();
      log('initial uri function with no URI');
      if (uri == null) {
        log('about to call incoming links');
        _handleIncomingLinks();
      } else {
        log('ELSE PART of initialURI: $uri');

        _navigate(uri, gotoHome: true);
      }
    } on PlatformException {
      log('falied to get initial uri');
    } on FormatException catch (err) {
      log('malformed initial uri $err');
    }
  }

  void _navigate(url, {bool gotoHome = false}) {
    if (!gotoHome) {
      log("ALREADY OPENED");

      Timer(Duration(seconds: Platform.isIOS ? 1 : 5), () {
        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => WebviewLink(url: url),
            ));
      });
    } else {
      log("ABOUT TO OPEN");
      // Navigator.pushNamedAndRemoveUntil(
      //     navigatorKey.currentContext!, Tabs.path, (route) => false);
      Timer(const Duration(seconds: 5), () {
        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => WebviewLink(url: url),
            ));
      });
    }
  }

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
            onGenerateRoute: Routes.getRouteGenerate,
          ),
        );
      },
      child: const Splash(),
      // child: const WebPageUI(),
    );
  }
}
