import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

/// [DynamicLinkService]

class DynamicLinkService {
  static final DynamicLinkService _singleton = DynamicLinkService._internal();
  DynamicLinkService._internal();
  static DynamicLinkService get instance => _singleton;

// Create new dynamic link
  void createDynamicLink(code) async {
    log("Refere code = $code");
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://app.stocks.news/install?code=$code&_id=${user?.userId}"),
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

  Future<Uri> getDynamicLink(code) async {
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://app.stocks.news/install?code=$code&_id=${user?.userId}"),
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

    return dynamicLink.shortUrl;

    // Share.share(
    //   "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${dynamicLink.shortUrl}",
    // );

    // Utils().showLog("DYNAMIC LINKS ***** %%%%%%  ${dynamicLink.shortUrl}");
  }

// Create new dynamic link
//   void createDynamicLinkFromBranchIO(code) async {
//     try {
//       log("Refere code = $code");
//       UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
//       // final dynamicLinkParams = DynamicLinkParameters(
//       //   link: Uri.parse(
//       //       "https://app.stocks.news/install?code=$code&_id=${user?.userId}"),
//       //   // link: Uri.parse(
//       //   //     "https://app.stocks.news/news/nasdaq-mints-record-breaking-week-wall-streets-new-fast-food-darling-jumps-300"),
//       //   uriPrefix: "https://stocksnews.page.link",
//       //   androidParameters: const AndroidParameters(
//       //     packageName: "com.stocks.news",
//       //     minimumVersion: 0,
//       //   ),
//       //   iosParameters: const IOSParameters(
//       //     bundleId: "app.stocks.news",
//       //   ),
//       // );
//       // final dynamicLink =
//       //     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
//       // debugPrint("${dynamicLink.shortUrl}");
//       // Get Branch object from the SDK
// // Branch branch = Branch.getInstance();
// // // Define data for the referral link (including referring user ID)
// // HashMap<String, String> data = new HashMap<String, String>();
// // data.put("$referring_user_id", "YOUR_USER_ID");
//       BranchContentMetaData? contentMetadata =
//           BranchContentMetaData().addCustomMetadata("code", user?.referralCode);
// // Create a BranchUniversalObject (BUO) to represent the link content
//       BranchUniversalObject buo = BranchUniversalObject(
//         canonicalIdentifier:
//             "install/ABCD?code=${user?.referralCode}", // Optional content identifier
//         canonicalUrl: "https://app.stocks.news",
//         title: "Your App Name Referral",
//         contentDescription: "Join me on Stocks.News!",
//         publiclyIndex: true,
//         expirationDateInMilliSec: 5000000,
//         contentMetadata: contentMetadata,
//         locallyIndex: true,
//       );
//       Utils().showLog("DYNAMIC LINKS ***** %%%%%%  ${buo.toMap()}");
//       BranchResponse<dynamic> response = await FlutterBranchSdk.getShortUrl(
//         buo: buo,
//         linkProperties: BranchLinkProperties(
//             alias: "a",
//             campaign: "s",
//             channel: "ss",
//             feature: "s",
//             matchDuration: 1,
//             stage: "s",
//             tags: ["sds"]),
//       );
//       String link = response.result.toString();
//       Utils().showLog("DYNAMIC LINKS ***** %%%%%%  ${response}");
//       Share.share(
//         "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${link}",
//       );
//       Utils().showLog("DYNAMIC LINKS ***** %%%%%%  ${link}");
//     } catch (e) {
//       //
//     }
//   }
}
