import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

/// [DynamicLinkService]

class DynamicLinkService {
  static final DynamicLinkService _singleton = DynamicLinkService._internal();
  DynamicLinkService._internal();
  static DynamicLinkService get instance => _singleton;

// Create new dynamic link
  void createDynamicLink(code) async {
    log("Refere code = $code");

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://app.stocks.news/install?code=${code}"),
      // link: Uri.parse(
      //     "https://app.stocks.news/news/nasdaq-mints-record-breaking-week-wall-streets-new-fast-food-darling-jumps-300"),
      uriPrefix: "https://stocksnews.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.stocks.news",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "app.stocks.news",
      ),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    debugPrint("${dynamicLink.shortUrl}");

    Share.share(
      "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${dynamicLink.shortUrl}",
    );

    Utils().showLog("DYNAMIC LINKS ***** %%%%%%  ${dynamicLink.shortUrl}");
  }
}
