import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:provider/provider.dart';
import '../drawer/widgets/review_app_pop_up.dart';

class HomeSplash extends StatefulWidget {
  static const path = "HomeSplash";

  const HomeSplash({super.key});

  @override
  State<HomeSplash> createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAppLinks();
    });
  }

  void _getAppLinks() {
    if (deepLinkData != null) {
      String type = containsSpecificPath(deepLinkData!);
      String slug = extractLastPathComponent(deepLinkData!);

      // Timer(const Duration(seconds: 5), () {
      //   _navigation(uri: event, slug: slug, type: type);
      // });

      _navigationToDeepLink(uri: deepLinkData!, slug: slug, type: type);
    } else {
      _navigation();
    }
  }

  _navigationToDeepLink({String? type, required Uri uri, String? slug}) async {
    try {
      Utils().showLog("---Type $type, -----Uri $uri,-----Slug $slug");
      String slugForTicker = extractSymbolValue(uri);
      Utils().showLog("slug for ticker $slugForTicker");
      bool userPresent = false;

      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      if (await provider.checkForUser()) {
        userPresent = true;
      }
      Utils().showLog("----$userPresent---");
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
            builder: (context) => StockDetails(symbol: slugForTicker),
          ),
        );
      } else if (type == "login") {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Tabs.path,
          (route) => false,
        );

        if (userPresent) {
          //
        } else {
          // loginSheet();
          Timer(const Duration(seconds: 1), () {
            loginSheet();
          });
        }
        deepLinkData = null;
      } else if (type == "signUp") {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Tabs.path,
          (route) => false,
        );

        if (userPresent) {
          //
        } else {
          Timer(const Duration(seconds: 1), () {
            signupSheet();
          });
        }
        deepLinkData = null;
      } else if (type == "dashboard") {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Tabs.path,
          (route) => false,
        );

        //
        Utils().showLog("--goto dashboard---");
        deepLinkData = null;
      } else {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: ((context) => WebviewLink(url: uri)),
          ),
        );
      }
    } catch (e) {
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        Tabs.path,
        (route) => false,
      );
      deepLinkData = null;
    }
  }

  _navigation() {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value == null) {
        Navigator.pushNamedAndRemoveUntil(context, Tabs.path, (route) => false);
      } else {
        _navigateToRequiredScreen(value.data);
      }
    });
  }

  _navigateToRequiredScreen(payload) {
    popHome = true;
    String? type = payload["type"];
    String? slug = payload['slug'];
    String? notificationId = payload['notification_id'];
    try {
      // String? type = payload["type"];
      // String? slug = payload['slug'];
      // String? notificationId = payload['notification_id'];

      if (type == NotificationType.dashboard.name) {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Tabs.path,
          (route) => false,
        );
      } else if (slug != '' && type == NotificationType.newsDetail.name) {
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          NewsDetails.path,
          arguments: {"slug": slug, "notificationId": notificationId},
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          BlogDetail.path,
          arguments: {"slug": slug, "notificationId": notificationId},
        );
        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => BlogDetail(
        //       slug: slug ?? "",
        //     ),
        //   ),
        // );
      } else if (slug != '' && type == NotificationType.register.name) {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Tabs.path,
          (route) => false,
        );
        Timer(const Duration(seconds: 1), () {
          signupSheet();
          popHome = false;
        });
      } else if (slug != '' && type == NotificationType.review.name) {
        //review pop up
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Tabs.path,
          (route) => false,
        );

        Timer(const Duration(seconds: 1), () {
          showDialog(
            context: navigatorKey.currentContext!,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) {
              return const ReviewAppPopUp();
            },
          );
          popHome = false;
        });
      } else {
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          StockDetails.path,
          arguments: {"slug": type, "notificationId": notificationId},
        );
      }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        Tabs.path,
        (route) => false,
      );
      popHome = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
        appBar: AppBarHome(
          canSearch: true,
          showTrailing: true,
        ),
        body: SizedBox());
  }
}
