// ignore_for_file: unused_element

import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/dummy.dart';
import 'package:stocks_news_new/route/routes.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

final _appLinks = AppLinks();
//
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;

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
      _getAppLinks();
      Timer(const Duration(milliseconds: 7200), () {
        _checkForConnection();
      });
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isAppInForeground = state == AppLifecycleState.resumed;
    // log("**** is in foreground ==>  $isAppInForeground");
    setState(() {
      _appLifecycleState = state;
    });
  }

  void _getAppLinks() {
    _appLinks.uriLinkStream.listen((event) {
      String type = containsSpecificPath(event);
      String slug = extractLastPathComponent(event);
      if (_appLifecycleState == null) {
        Timer(const Duration(seconds: 5), () {
          _navigation(uri: event, slug: slug, type: type);
        });
      } else {
        Timer(const Duration(seconds: 1), () {
          _navigation(uri: event, slug: slug, type: type);
        });
      }
    });
  }

  String extractLastPathComponent(Uri uri) {
    List<String> parts = uri.pathSegments;
    return parts.isNotEmpty ? parts.last : '';
  }

  String extractSymbolValue(Uri uri) {
    if (uri.path.contains('/stock-detail')) {
      // Check if the query parameters contain 'symbol'
      if (uri.queryParameters.containsKey('symbol')) {
        return uri.queryParameters['symbol'] ?? '';
      }
    }
    return '';
  }

  _navigation({String? type, required Uri uri, String? slug}) {
    log("---Type $type, -----Uri $uri,-----Slug $slug");
    String slugForTicker = extractSymbolValue(uri);
    log("slug for ticker $slugForTicker");
    if (type == "blog") {
      Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => BlogDetail(
                    // id: "",
                    slug: slug,
                  )));
    } else if (type == "news") {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => NewsDetails(
            slug: slug,
          ),
        ),
      );
    } else if (type == "stock_detail") {
      Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => StockDetails(symbol: slugForTicker)));
    } else if (type == "dashboard") {
      if (_appLifecycleState == null) {
        //
      } else {
        // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path);
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Tabs.path, (route) => false);
      }
      Utils().showLog("--goto dashboard---");
    } else {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: ((context) => WebviewLink(
                url: uri,
              )),
        ),
      );
    }
  }

  String containsSpecificPath(Uri uri) {
    log("-----contain path $uri");
    if (uri.path.contains('/blog/')) {
      return "blog";
    } else if (uri.path.contains('/stock-detail')) {
      return "stock_detail";
    } else if (uri.path.contains('/news/')) {
      return 'news';
    } else if (uri.toString() == "https://app.stocks.news/" ||
        uri.toString() == "https://app.stocks.news") {
      return 'dashboard';
    } else {
      return '';
    }
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
      // child: const DemoWeb(),
      // child: const InternetErrorWidget(),
    );
  }
}
