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

import '../auth/bottomSheets/signup_sheet.dart';
import '../blogDetail/index.dart';
import '../deepLinkScreen/webscreen.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _navigation();
    });
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
